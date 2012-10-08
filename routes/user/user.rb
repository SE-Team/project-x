## Sinatra/Web################################################
##############################################################
require 'sinatra'
require 'haml'
##############################################################

## Helpers ###################################################
##############################################################
require './helpers/helpers'
require './helpers/sinatra'
##############################################################

## DataMapper ################################################
##############################################################
require './model/base'
require 'dm-serializer'

## Controllers ###############################################
##############################################################
require './controllers/form'
require './controllers/user/sidebar'
require './controllers/event/tile'
##############################################################

##############################################################
### Controller includes ######################################
include Helpers
include FormController
include UserSidebarController
include TileController
include NewThingController
##############################################################

## Events ####################################################
##############################################################
get '/user/:user_name/dashboard' do
  @user = User.first(user_name: session[:user])
  unless @user.nil?
    @categories = @user.account_setting.categories.split('&')
    @content = partial(:'user/dashboard', {events: @user.events, categories: @categories})
    @sidebar = user_sidebar(@user)
    return haml :with_sidebar, layout: :'layout/user'
  else
    redirect '/'
  end
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
##############################################################

post '/user/:username/event/:event_id/comment' do
  event = Event.first(id: params["event_id"])
  ## if a user is logged in comment with their name, otherwise call them guest
  if event
    email = nil
    body = nil
    posted_by = nil
    if logged_in?
      user = User.first(user_name: session[:user])
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
  redirect "/user/#{params["username"]}/event/#{params["event_id"]}"
end

## Account ###################################################
##############################################################
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
##############################################################

## Messaging #################################################
##############################################################
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

get '/user/:username/message/create' do
  @user = User.first(user_name: session[:user])
  @content = partial(:'message/create_message', {user: @user, source: @user.user_name, subject: ""})
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

post '/user/:user_name/message' do
  @user = User.first(user_name: session[:user])
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
##############################################################

##############################################################
##############################################################
get '/user/:username/new-thing' do
  @user = User.first(user_name: session[:user])
  more_stuff = new_thing_data
  @content = partial(:'user/new_thing', {info_array: ["hello", "world"], new_array: more_stuff})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

##############################################################
