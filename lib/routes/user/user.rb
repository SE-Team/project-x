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
def categories
  ["outdoor",
  "personal",
  "music",
  "tv",
  "movies",
  "entertainment",
  "art",
  "community",
  "etc",
  "school",
  "sports",
  "political",
  "charity"]
end

get '/user/:user_name/stream' do
  @user = current_user
  unless @user.nil?
    @categories = categories
    @sidebar = user_sidebar(@user)
    @breadcrumbs = bread_crumbs_partial request.path_info.split('/')
    haml :'user/dashboard', locals: {categories: @categories}, layout: :'layout/user'
  else
    redirect '/'
  end
end

get '/user/:user_name/events' do
  @user = current_user
  unless @user.nil?
    @categories = categories
    @sidebar = user_sidebar(@user)
    @breadcrumbs = bread_crumbs_partial request.path_info.split('/')
    haml :'user/events', locals: {categories: @categories}, layout: :'layout/user'
  else
    redirect '/'
  end
end

get '/user/:username/friends' do
  @user = current_user
  @sidebar = user_sidebar(@user)
  @breadcrumbs = bread_crumbs_partial request.path_info.split('/')
  haml :'user/friends', locals: {user: @user}, layout: :'layout/user'
end

get '/user/:username/event/:event_id' do
  @user = current_user
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
      user = current_user
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
  @user = current_user
  @content = partial(:'user/account', {user: @user})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

get '/user/:username/profile' do
  @user = current_user
  @content = partial(:'user/profile', {user: @user})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end
##############################################################

## Messaging #################################################
##############################################################
get '/user/:username/messages' do
  # authenticate the user by name and session id first
  @user = current_user
  unless @user == nil
    @content = partial(:'user/messages', {user: @user})
    @sidebar = user_sidebar(@user)
    haml :with_sidebar
  else
    redirect '/'
  end
end

get '/user/:username/rmessage/:msg_id' do
  @user = current_user
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
  @user = current_user
  @content = partial(:'message/create_message', {user: @user, source: @user.user_name, subject: ""})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

get '/user/:username/smessage/:msg_id' do
  @user = current_user
  @msg = SMessage.first(id: params[:msg_id])
  @content = partial(:'user/smessage', {user: @user, msg: @msg})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

post '/user/:user_name/message' do
  @user = current_user
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
  @user = current_user
  form_map = create_event_event_form
  @content = partial(:'event/create_event')
  # @content = partial(:form, {form_map: form_map})
  @sidebar = user_sidebar(@user)
  haml :with_sidebar
end

post'/user/:username/create-event' do
  @user = current_user
  @event = Event.new
  @event.location = params["location"]
  @event.start_date = DateTime.strptime(params["start"], '%m/%d/%Y %H:%M') if params["start"]
  @event.end_date = DateTime.strptime(params["end"], '%m/%d/%Y %H:%M') if params["end"]
  @event.title = params["title"]
  @event.body = params["body"]
  @event.img_url = params["image-url"]
  # @event.video_url = params["video-url"]
  @event.user = @user
  if @event.save
    category = Category.create(event: @event)
    @event.category.name = params["category"]
    if @event.save
      flash("Event created")
      redirect '/user/' << current_user.user_name << "/stream"
    end
  else
    tmp = []
    event.errors.each do |e|
      tmp << (e.join("<br/>"))
    end
    flash(tmp)
    redirect '/user/:username/create-event'
  end
  redirect '/user/' << current_user.user_name << "/stream"
end
##############################################################

##############################################################
## Following #################################################
get '/user/:username/followers' do
  @user = current_user
  if @user
    @users = @user.followers
    @content = partial :'user/followers', users: @users, title: "Followers"
    @sidebar = user_sidebar @user
    haml :with_sidebar
  else
    redirect '/'
  end
end

get '/user/:username/following' do
  @user = current_user
  if @user
    @users = @user.following
    @content = partial :'user/following', users: @users, title: "Following"
    @sidebar = user_sidebar @user
    haml :with_sidebar
  else
    redirect '/'
  end
end
##############################################################

post '/user/:username/account' do
  @user = current_user
  @user.display_name = params[:display_name]
  @user.location = params[:location]
  @user.save!
  redirect '/'
end

