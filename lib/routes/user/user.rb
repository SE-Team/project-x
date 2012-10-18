## Sinatra/Web################################################
##############################################################
require 'sinatra'
require 'haml'
##############################################################

## Helpers ###################################################
##############################################################
require './lib/helpers/helpers'
require './lib/helpers/sinatra'
##############################################################

## DataMapper ################################################
##############################################################
require './lib/model/base'
require 'dm-serializer'
##############################################################

## Controllers ###############################################
##############################################################
require './lib/controllers/user/sidebar'
require './lib/controllers/event/tile'
require './lib/controllers/event/create'
require './lib/controllers/navbar/navbar'
require './lib/controllers/bread_crumbs/bread_crumbs'
##############################################################

##############################################################
### Controller includes ######################################
include Helpers
include CreateEventController
include UserSidebarController
include TileController
include BreadCrumbsController
include NavbarController
##############################################################

## Events ####################################################
##############################################################
get '/user/:user_name/dashboard' do
  @user = session[:user]
  unless @user.nil?
    @categories = @user.account_setting.categories.split('&')
    @sidebar = user_sidebar(@user)
    @breadcrumbs = bread_crumbs_partial request.path_info.split('/')
    haml :'user/dashboard', locals: {categories: @categories}, layout: :'layout/user'
  else
    redirect '/'
  end
end

get '/user/:username/friends' do
  @user = session[:user]
  @sidebar = user_sidebar(@user)
  @breadcrumbs = bread_crumbs_partial request.path_info.split('/')
  haml :'user/friends', locals: {user: @user}, layout: :'layout/user'
end

get '/user/:username/event/:event_id' do
  @user = session[:user]
  @event = Event.first(id: params[:event_id])
  @sidebar = user_sidebar(@user)
  @breadcrumbs = bread_crumbs_partial request.path_info.split('/')
  haml :'event/event', locals: {user: @user, event: @event}, layout: :'layout/user'
end
##############################################################

post '/user/:username/event/:event_id/comment' do
  event = Event.first(id: params["event_id"])
  ## if a user is logged in comment with their name, otherwise call them guest
  if event
    email = nil
    body = nil
    posted_by = nil
    if logged_in?
      user = session[:user]
      posted_by = user.user_name
      email = user.email
      body = params["body"]
    else
      posted_by = "guest"
      email = params["email"]
      body = params["body"]
    end
    tumbler = event.tumbler
    comment = Comment.create(tumbler: event.tumbler,
                             email: email,
                             posted_by: posted_by,
                             body: body,
                             tumbler_id: tumbler.id,
                             tumbler_event_id: event.id)
    event.tumbler.comments << comment
  end
  redirect "/user/#{params["username"]}/event/#{params["event_id"]}#C#{comment.id}"
end

## Account ###################################################
##############################################################
get '/user/:username/account' do
  @user = session[:user]
  @content = partial(:'user/account', {user: @user})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

get '/user/:username/profile' do
  @user = session[:user]
  @content = partial(:'user/profile', {user: @user})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end
##############################################################

## Messaging #################################################
##############################################################
get '/user/:username/messages' do
  # authenticate the user by name and session id first
  @user = session[:user]
  unless @user == nil
    @content = partial(:'user/messages', {user: @user})
    @sidebar = user_sidebar(@user)
    haml :with_sidebar
  else
    redirect '/'
  end
end

get '/user/:username/rmessage/:msg_id' do
  @user = session[:user]
  @msg = RMessage.first(id: params[:msg_id])
  if @msg.new_message
    @msg.new_message = false
    @msg.save
  end
  @content = partial(:'user/rmessage', {user: @user, msg: @msg})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

get '/user/:username/message/create' do
  @user = session[:user]
  @content = partial(:'message/create_message', {user: @user, source: @user.user_name, subject: ""})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

get '/user/:username/smessage/:msg_id' do
  @user = session[:user]
  @msg = SMessage.first(id: params[:msg_id])
  @content = partial(:'user/smessage', {user: @user, msg: @msg})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

post '/user/:user_name/message' do
  @user = session[:user]
  target = User.first(user_name: params[:target_user])
  message = SMessage.create(body: params[:message_body], subject: params[:message_subject], user: @user)
  if message.save
    target = User.first(user_name: params[:target_user])
    message.send(target)
    redirect "/user/#{params[:user_name]}/messages"
  else
    redirect "/user/#{params[:user_name]}/messages"
  end
end
##############################################################

## Event creation ############################################
##############################################################
get '/user/:username/create-event' do
  @user = session[:user]
  form_map = create_event_event_form
  @content = partial(:form, {form_map: form_map})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

post'/user/:username/create-event' do
  @user = session[:user]
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
    redirect '/user/' << session[:user].user_name << "/dashboard"
  else
    tmp = []
    event.errors.each do |e|
      tmp << (e.join("<br/>"))
    end
    flash(tmp)
    redirect '/user/:username/create-event'
  end
end
##############################################################
