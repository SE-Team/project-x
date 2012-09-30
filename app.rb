require 'open-uri'
require './model/dm'
require './helpers/helpers'
require './helpers/sinatra'
require 'dm-serializer'
require 'sinatra'
require 'haml'
require 'json'
require 'pp'

require 'google/api_client'

DataMapper::Logger.new(STDOUT, :debug)

configure do
  enable :sessions
end

include Helpers

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

def user_sidebar_items(user)
  [{href: "/user/#{user.user_name}/dashboard", icon: "icon-home", title: "Stream"},
   {href: "/user/#{user.user_name}/messages", icon: "icon-envelope", title: "Messages", badge: {value: "#{user.r_messages.all(new_message: true).count}"}},
   {href: "/user/#{user.user_name}/dashboard", icon: "icon-comment", title: "Comments", badge: {value: rand(10)}},
   :divider,
   {href: "/user/#{user.user_name}/friends", icon: "icon-user", title: "Friends"},
   {href: "/user/#{user.user_name}/following", icon: "icon-tag", title: "Following", badge: {value: "#{user.followed_people.count}"}},
   {href: "/user/#{user.user_name}/followers", icon: "icon-tags", title: "Followers", badge: {value: "#{user.followers.count}"}},
   :divider,
   {href: "/user/#{user.user_name}/dashboard", icon: "icon-th", title: "Events", badge: {value: "#{user.events.all(permission: "public").count}"}},
   {href: "/user/#{user.user_name}/create-event", icon: "icon-flag", title: "Create Event"},
   {href: "/search/", icon: "icon-search", title: "Search"},
   :divider,
   {href: "/user/#{user.user_name}/account", icon:  "icon-pencil", title: "Settings"},
   {href: "/logout", icon: "icon-off", title: "Logout"}]
end

def user_sidebar(user)
  @map = {title: user.user_name,
          items: user_sidebar_items(user)}
  @sidebar = partial(:'user/sidebar', {map: @map})
end

get '/' do
  @user = User.first(user_name: session[:user])
  if session[:token_id]
    if token_pair = TokenPair.first(id: session[:token_id].to_i) 
      pp token_pair
      # @client.authorization.update_token!(token_pair.to_hash)
    end
  end
  unless @user == nil
    @user_name = session[:user]
  end
  haml :index
end

get '/user/:user_name/dashboard' do
  @user = User.first(user_name: session[:user])
  unless @user.nil?
    @categories = @user.account_setting.categories.split('&')
    @content = partial(:'user/dashboard', {events: @user.events, categories: @categories})
    @sidebar = user_sidebar(@user)
    return haml :with_sidebar
  else
    redirect '/'
  end
end

get '/search/:args' do
  search_term = "%"
  search_term << params[:args].gsub('%20', '%')
  search_term << "%"
  e1 = Event.all(:title.like => search_term, permission: "public")
  e2 = Event.all(:category_name.like => search_term, permission: "public")
  @events = e1.zip(e2).flatten.compact
  categories = Set[]
  @events.each do |e|
    categories.add(e.category.name)
  end
  @categories = categories
  @content = partial(:'search/response', {events: @events, categories: @categories, search_term: params[:args].gsub('%20', ' ')})
  haml :partial_wrapper
end

get '/user/:username/friends' do
  @user = User.first(user_name: session[:user])
  @content = partial(:'user/friends', {user: @user})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

get '/user/:username/event/:event_id' do
  # @user = session[:user]
  @user = User.first(user_name: session[:user])
  @event = Event.first(id: params[:event_id])
  @content = partial(:'event/event', {user: @user, event: @event})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

get '/user/:username/account' do
  @user = User.first(user_name: session[:user])
  @content = partial(:'user/account', {user: @user})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

get '/user/:username/profile' do
  @user = User.first(user_name: session[:user])
  @content = partial(:'user/profile', {user: @user})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

get '/user/:username/messages' do
  # authenticate the user by name and session id first
  @user = User.first(user_name: session[:user])
  unless @user == nil
    @content = partial(:'user/messages', {user: @user})
    @sidebar = user_sidebar(@user)
    # print_session_data(session, @user)
    haml :with_sidebar
  else
    redirect '/'
  end
end

get '/user/:username/rmessage/:msg_id' do
  @user = User.first(user_name: session[:user])
  @msg = RMessage.first(id: params[:msg_id])
  if @msg.new_message
    @msg.new_message = false
    @msg.save
  end
  @content = partial(:'user/rmessage', {user: @user, msg: @msg})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

get '/user/:username/smessage/:msg_id' do
  @user = User.first(user_name: session[:user])
  @msg = SMessage.first(id: params[:msg_id])
  @content = partial(:'user/smessage', {user: @user, msg: @msg})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

post '/user/:user_name/message/:msg_id' do
  @user = session[:user]
  target = User.first(user_name: params[:target_user])
  message = SMessage.create(body: params[:message_body], subject: params[:message_subject], user: @user)
  if message.save
    target = User.first(user_name: params[:target_user])
    message.send(target)
    redirect "/user/#{params[:user_name]}/smessage/#{message.id}"
  else
    redirect "/user/#{params[:user_name]}/rmessage/#{params[:msg_id]}"
  end
end

get '/user/:username/create-event' do
  @user = User.first(user_name: session[:user])
  @content = partial(:form, {form_map: event_form})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

post'/user/:username/create-event' do
  @user = User.first(user_name: session[:user])
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
    redirect '/user/' << session[:user] << "/dashboard"
  else
    tmp = []
    event.errors.each do |e|
      tmp << (e.join("<br/>"))
    end
    flash(tmp)
    redirect '/user/:username/create-event'
  end
end

# get '/user/dashboard' do
#   if session[:user] == nil
#     @user_name = session[:user].user_name
#     haml :'user/dashboard'
#   else
#     haml :no_user_dash
#   end
# end

get '/user' do
  redirect '/user/' + session[:user]
end

get '/about' do
  unless session[:user] == nil
    @user_name = session[:user]
  end
  haml :about
end

get '/contact' do
  haml :contact
end

get '/user/:username/profile' do
  @user = User.first(user_name: session[:user])
  unless session[:user] == nil
    @user_name = session[:user]
  end
  haml :'user/profile'
end

get '/login' do
  # @map = {action: "/login",
  #         title: "Login"}
  # haml :login
  unless @client.authorization.access_token || request.path_info =~ /^\/oauth2/
    redirect to('/oauth2authorize')
  end
end

post '/login' do
    # Create a unique id for this user session
    # make sure the id saved
  if @user = User.authenticate(params["username"], params["password"])
    session[:user] = @user.user_name
    flash("Login successful")
    redirect "/user/" << session[:user] << "/dashboard"
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
  u.user_name =   params[:user_name]
  u.password =    params[:password]
  u.email =       params[:email]

  if u.save
    flash("User created")
    redirect '/login'
  else
    tmp = []
    # u.errors.each do |e|
    #   tmp << (e.join("<br/>"))
    # end
    flash(tmp)
    # redirect '/'
    "didn't work"
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
  if @user = Admin.authenticate(params["username"], params["password"])
    session[:user] = @user.user_name
    flash("Admin login successful")
    redirect "/admin/" << session[:user] << "/dashboard"
  else
    flash("Admin login failed - Try again")
    redirect '/admin/login'
  end
end

get '/admin/:admin_user/dashboard' do
  @admin = Admin.first(user_name: session[:user])
  @users = User.all
  @content = partial(:'admin/dashboard', {admin: @admin, users: @users, api_keys: ApiKey.all})
  @items = [{href: "#", icon: "icon-home", title: "Dashboard"},
            {href: "#", icon: "icon-envelope", title: "Messages", badge: {value: rand(100)}},
            {href: "#", icon: "icon-comment", title: "Comments", badge: {value: rand(100)}},
            {href: "#", icon: "icon-user", title: "Members"},
            :divider,
            {href: "#", icon: "icon-wrench", title: "Settings"},
            {href: "#", icon: "icon-share", title: "Logout"}]
  @map = {title: "Admin",
          items: @items}
  @sidebar = partial(:'admin/sidebar', {map: @map})
  haml :with_sidebar
end

get '/util/test.html' do
  partial(:form, {form_map: event_form})
end

def render_pane(pane_map)
  partial(:'looking_glass/tile', {map: pane_map})
end

# def render_twitter_pane(pane_map)
#   partial(:'looking_glass/twitter_tile', {map: pane_map})
# end

def safe_to_like_message(u, id)
  user = User.first(user_name: u)
  messages = RMessage.all(user: user, id: id)
  exists = messages.count == 0
  if exists
    msg = messages.first
    msg.start = true
    return msg.save
  end
  return false
end



# get '/twitter-search/:args' do
#   search = TwitterSearch.search({q: params[:args], count: 1000})
#   results = search["results"]
#   @events = results.map do |tweet|
#     {title: tweet["text"],
#      img_url: tweet["profile_image_url"],
#      event_time: tweet["created_at"],
#      category: "twitter",
#      classes: "twitter",
#      id: tweet["id"]}
#   end
#   @categories = ["twitter"]
#   @content = partial(:'search/twitter_response', {events: @events, categories: @categories, search_term: params[:args].gsub('%20', ' ')})
#   haml :partial_wrapper
# end

before do
  @client = Google::APIClient.new
  @client.authorization.client_id = '4225099662.apps.googleusercontent.com'
  @client.authorization.client_secret = 'NlEMrLKkOkaPo1Y8UrwDeE5q'
  @client.authorization.scope = "https://accounts.google.com/o/oauth2/device/code"
  # " https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email"
  @client.authorization.redirect_uri = to("/oauth2callback")
  @client.authorization.code = params[:code] if params[:code]
  # if session[:token_id]
  #   # Load the access token here if it's available
  #   token_pair = TokenPair.get(session[:token_id])
  #   @client.authorization.update_token!(token_pair.to_hash)
  # end
  # if @client.authorization.refresh_token && @client.authorization.expired?
  #   @client.authorization.fetch_access_token!
  # end
  # @buzz = @client.discovered_api('indentity')
  # unless @client.authorization.access_token || request.path_info =~ /^\/oauth2/
  #   redirect to('/oauth2authorize')
  # end
end

get '/oauth2authorize' do
  redirect @client.authorization.authorization_uri.to_s, 303
end

get '/oauth2callback' do
  puts
  puts "oauth2callback"
  token = @client.authorization.fetch_access_token!
  # Persist the token here
  token_pair = TokenPair.create(access_token: token["access_token"])
  token_pair.update(:refresh_token => token["refresh_token"],
                    :id_token => token["id_token"],
                    :token_type => token["token_type"],
                    :expires_in => token["expires_in"])

  token_pair.save

  if response = open("https://www.googleapis.com/oauth2/v1/userinfo?access_token=#{token_pair.access_token}").read
    r_hash = JSON.parse(response)
    email = r_hash["email"]
    user = User.first(user_name: email)
    if user
      puts user.user_name
      session[:token_id] = token_pair.id
      session[:user] = user.user_name
      redirect to("/user/#{user.user_name}/dashboard")
    else
      user = User.create(user_name: email)
      session[:token_id] = token_pair.id
      session[:user] = user.user_name
      redirect to("/user/#{user.user_name}/dashboard")
    end
  end
  # session[:token_id] = nil
  # redirect to('/')
end
