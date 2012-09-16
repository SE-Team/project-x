require './model/dm'
require './helpers/helpers'
require './helpers/sinatra'
require 'dm-serializer'
require 'sinatra'
require 'haml'
require 'json'

configure do
  enable :sessions
end

include Helpers

# def partial(template,locals=nil)
#   if template.is_a?(String) || template.is_a?(Symbol)
#     template=(template.to_s).to_sym
#   else
#     locals=template
#     template=template.is_a?(Array) ? (template.first.class.to_s.downcase).to_sym : (template.class.to_s.downcase).to_sym
#   end
#   if locals.is_a?(Hash)
#     haml(template,{:layout => false},locals)      
#   elsif locals
#     locals=[locals] unless locals.respond_to?(:inject)
#     locals.inject([]) do |output,element|
#       output <<     erb(template,{:layout=>false},{template.to_s.delete("_").to_sym => element})
#     end.join("\n")
#   else 
#     haml(template,{:layout => false})
#   end
# end


def user_sidebar_items
  [["Stream", "user/" + @user.user_name + "/stream"],
            ["Profile", "user/" + @user.user_name + "/profile"],
            ["Friends", "user/" + @user.user_name + "/friends"],
            ["Search", "user/" + @user.user_name + "/search"],
            ["Account", "user/" + @user.user_name + "/account"]]
end

def time_info
  {title: "Time",
   input_fields: [{name: "start-date", type: :date, placeholder: "start-date"},
                  {name: "start", type: :text, placeholder: "starting (12:00:00)"},
                  {name: "end-date", type: :date, placeholder: "end-date"},
                  {name: "end", type: :text, placeholder: "ending (12:00:00)"}]}
end

def location_info
  {title: "Location",
   input_fields: [{name: "city", type: :text, placeholder: "city"},
                  {name: "country", type: :text, placeholder: "country"},
                  {name: "country-code", type: :text, placeholder: "country code"}]}
end

def event_info
  {title: "Event Info",
   input_fields: [{name: "title", type: :text, placeholder: "title"},
                  {name: "body", type: :text, placeholder: "body"}]}
end

def event_form
  {title: "Create an Event",
   elements: [event_info,
              time_info,
              location_info],
   action: "/create-event",
   method: "post"}
end

get '/' do
  @user = session[:user]
  unless @user == nil
    @user_name = session[:user].user_name
  end
  haml :index
end

get '/user/:username/dashboard' do
  @user = session[:user]
  @content = partial(:'user/dashboard', {user: @user})
  @items = user_sidebar_items
  @sidebar = partial(:sidebar, {items: @items})
  haml :with_sidebar
end

get '/user/:username/create-event' do
  @user = User.first(user_name: params[:username])
  @content = partial(:form, {form_map: event_form})
  @items = user_sidebar_items
  @sidebar = partial(:sidebar, {items: @items})
  haml :with_sidebar
end

post'/user/:username/create-event' do
  @user = User.first(user_name: params[:username])
  event = Event.new
  event.user = @user
  event.title = params["title"]
  event.body = params["body"]
  
  time = Time.new
  time.event = event

  location = Location.new
  location.event = event
  location.geo_location = params["country-code"]
  location.city = params["city"]
  location.country = params["country"]

  if event.save && time.save && location.save
    flash("Event created")
    redirect '/user/' << session[:user].user_name.to_s << "/dashboard"
  else
    tmp = []
    event.errors.each do |e|
      tmp << (e.join("<br/>"))
    end
    flash(tmp)
    redirect '/user/:username/create-event'
  end
end

get '/user/dashboard' do
  if session[:user] == nil
    @user_name = session[:user].user_name
    haml :'user/dashboard'
  else
    haml :no_user_dash
  end
end

get '/user' do
  redirect '/user/' + session[:user].user_name
end

get '/about' do
  unless session[:user] == nil
    @user_name = session[:user].user_name
  end
  haml :about
end

get '/contact' do
  haml :contact
end

get '/user/:username/profile' do
  @user = User.first(user_name: params[:username])
  unless session[:user] == nil
    @user_name = session[:user].user_name
  end
  haml :'user/profile'
end

get '/login' do
  @map = {action: "/login",
          title: "Login"}
  haml :login
end

post '/login' do
  if session[:user] = User.authenticate(params["username"], params["password"])
    flash("Login successful")
    redirect "/user/" << session[:user].user_name << "/dashboard"
  else
    flash("Login failed - Try again")
    redirect '/login'
  end
end

get '/logout' do
  session[:user] = nil
  flash("Logout successful")
  redirect '/'
end

get '/list' do
  unless session[:user] == nil
    @user_name = session[:user].user_name
  end
  @users = User.all
  haml :list
end

get '/register' do
  haml :register
end

post '/register' do
  u = User.new
  u.user_name =   params[:username]
  u.password =    params[:password]
  u.email =       params[:email]
  
  if u.save
    flash("User created")
    session[:user] = User.authenticate( params["user_name"], 
                                        params["password"])
    redirect '/user/' << session[:user].user_name.to_s << "/dashboard"
  else
    tmp = []
    u.errors.each do |e|
      tmp << (e.join("<br/>"))
    end
    flash(tmp)
    redirect '/create'
  end
end

def api_info
  {title: "API User Info",
   input_fields: [{name: "email", type: :text, placeholder: "email"}]}
end

def api_form
  {title: "Register for an API key",
   elements: [api_info],
   action: "/api-key",
   method: "post"}
end

get '/api-key' do
  @content = partial(:form, {form_map: api_form})
  haml :with_sidebar
end

post '/api-key' do
  key = ApiKey.new
  key.email = params["email"]

  if key.save
    @key = key
    haml :key_created
  else
    redirect '/api-key'
  end
end

get '/api/:api_key/users.json' do
  valid_key = ApiKey.first(api_key: params["api_key"])
  if !valid_key.nil?
    User.all.to_json(only: [:id, :username, :email])
  end
end

get '/api/:api_key/user/:username.json' do
  User.first(user_name: params["user_name"]).to_json(only: [:username, :id, :email])
end

post '/api/:api_key/event/?' do
  valid_key = ApiKey.first(api_key: params[:api_key])
  if !valid_key.nil?
    event = Event.new
    event.title = CGI::unescape params[:title]
    if event.save
      event.to_json
    else
      "BAD ENTRY"
    end
  end
  redirect '/admin/admin/dashboard'
end

get '/api/:api_key/create-event$:opts' do
  valid_key = ApiKey.first(api_key: params[:api_key])
  if !valid_key.nil?
 	User.all.to_json(only: [:id, :username, :email])
	opts_str = params[:opts].to_s
	opts = opts_str.split "&"
	opts.each_with_index.map{|opt, i|
				kv = opt.split "="
				opts[i] = [kv[0], kv[1]]}
	event = Event.new
	opts.each do |opt|
		event[opt[0]] = opt[1]
		p event[opt[0]]
	end
	event.user = User.first
	if event.save
		event.to_json
	else
		"BAD ENTRY"
	end
	end
end

get '/dev/:dev-out' do
	params["dev-out"]
end

##############################################################################
########### ADMIN ############################################################
##############################################################################

get '/admin/login' do
  @map = {action: "/admin/login",
          title: "Admin Login"}
  haml :login
end

post '/admin/login' do
  if session[:user] = Admin.authenticate(params["username"], params["password"])
    flash("Admin login successful")
    redirect "/admin/" << session[:user].user_name << "/dashboard"
  else
    flash("Admin login failed - Try again")
    # puts params[:password]
    # puts Admin.first.password
    redirect '/admin/login'
  end
end

get '/admin/:admin_user/dashboard' do
  @admin = session[:user]
  @users = User.all
  @content = partial(:'admin/dashboard', {admin: @admin, users: @users, api_keys: ApiKey.all})
  # @items = [["Test", "/test/link"],
  #           ["Test", "/test/link"],
  #           ["Test", "/test/link"],
  #           ["Test", "/test/link"],
  #           ["Test", "/test/link"]]
  # @sidebar = partial(:sidebar, {items: @items})
  haml :'admin/dashboard', locals: {admin: @admin, users: @users, api_keys: ApiKey.all}
end



get '/util/test.html' do
  partial(:form, {form_map: event_form})
end

