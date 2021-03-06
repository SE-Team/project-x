
###############################################################
## Sinatra/Web ###############################################
##############################################################
require 'sinatra'
require 'haml'
##############################################################
## API Routes ################################################
##############################################################
require './lib/routes/admin/admin'
##############################################################
## Helpers ###################################################
##############################################################
require './lib/helpers/helpers'
require './lib/helpers/sinatra'
##############################################################
## DataMapper ################################################
##############################################################
require './lib/model/base'
##############################################################
## Controllers ###############################################
##############################################################
require './lib/controllers/form'
require './lib/controllers/api/api'
##############################################################
### Controller includes ######################################
##############################################################
include ApiController
##############################################################


require 'eventful/api'

@temp_key = "44:2c:03:30:95:3e"

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

post '/api/user/rmessage/star' do
  msg_id = params[:msg_id]
  msg = RMessage.first(id: msg_id)
  if msg
    ## toggle the star icon
    msg.star = msg.star ? false : true
  end
  msg.save
  return msg.star.to_s
end

post '/api/user/smessage/star' do
  msg_id = params[:msg_id]
  msg = SMessage.first(id: msg_id)
  if msg
    ## toggle the star icon
    msg.star = msg.star ? false : true
  end
  msg.save
  return msg.star.to_s
end

post "/api/user/events" do
  user = User.first(id: params[:user_id])
  response_str = ""
    user.events.each do |event|
      element = render_pane({title: event.title,
                             classes: event.category.name,
                             id: event.id,
                             category: event.category.name,
                             tumbler: event.tumbler,
                             event_time: event.event_date,
                             img_url: event.img_url,
                             user_name: event.user.user_name,
                             event: event})
      response_str << element
    end
  return response_str
end

post "/api/user/stream" do
  eventful = Eventful::API.new 'H5n5DpNG7ChgjJkH'
  eventful_response = eventful.call('events/search', location: "Chico, CA, USA", page_size: 100)
  response_str = ""
  user = User.first(id: params[:user_id])
  if user
    ## if valid user, then update new stream items
    ## for now just grabbing new events
    events = user.stream_events(100).uniq
    events.each do |event|
      element = render_pane({title: event.title,
                             classes: event.category.name,
                             id: event.id,
                             category: event.category.name,
                             tumbler: event.tumbler,
                             event_time: event.event_date,
                             img_url: event.img_url,
                             user_name: event.user.user_name,
                             event: event,
                             eventful: false})
      response_str += element
    end

    eventful_events = eventful_response["events"]["event"]
    eventful_events.each do |e|
      element = render_pane({eventful_event: e,
                             eventful: true})
      response_str += element
    end
  end
  return response_str
end

post "/api/user/stream/update" do
  response_str = ""
  user = User.first(id: params[:user_id])
  if user
    ## if valid user, then update new stream items
    ## for now just grabbing new events
    events = Event.all(:updated_at.gt => user.last_stream_request)
    range_vals = params[:range].split(" ")
    events = events[(range_vals[0].to_i..range_vals[1].to_i)]
    events.each do |event|
      element = render_pane({title: event.title,
                             classes: event.category.name,
                             id: event.id,
                             category: event.category.name,
                             tumbler: event.tumbler,
                             start_date: event.start_date,
                             end_date: event.end_date,
                             img_url: event.img_url,
                             user_name: event.user.user_name,
                             event: event})
      response_str += element
    end
  end
  # if events && events.count > 0
    user.update(last_stream_request: DateTime.now)
    user.save
  # end
  return response_str
end


#############################################

post '/api/sync/toggle_event' do
   @event = Event.get(params[:event_id])
   return @event.toggle_google_calendar_event(session[:user_uuid]).to_s
end

#############################################

################################################################################
## Follwing ####################################################################

post '/api/update/user/follow' do
  @followed_user = User.first(id: params[:followed_id])
  @follower_user = User.first(id: params[:follower_id])
  if @follower_user
    result = @follower_user.follow(@followed_user)
    return result.nil? ? "false" : "true"
  end
end

put '/api/update/user/unfollow' do
  @followed_user = User.first(id: params[:followed_id])
  @follower_user = User.first(id: params[:follower_id])
  if @follower_user
    result = @follower_user.unfollow(@followed_user)
    return result.nil? ? "false" : "true"
  end
end


################################################################################


