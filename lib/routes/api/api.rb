##############################################################
## Sinatra/Web################################################
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





















# get '/api/:api_key/users' do
#   valid_key = ApiKey.first(api_key: params["api_key"])
#   if !valid_key.nil?
#     User.all.to_json(only: [:id, :username, :email])
#   end
# end

# get '/api/:api_key/user/:username.json' do
#   User.first(user_name: params["user_name"]).to_json(only: [:username, :id, :email])
# end

# post '/api/:api_key/event/?' do
#   valid_key = ApiKey.first(api_key: params[:api_key])
#   if !valid_key.nil?
#     event = Event.new
#     event.title = CGI::unescape params[:title]
#     if event.save
#       event.to_json
#     else
#       "BAD ENTRY"
#     end
#   end
#   redirect '/admin/admin/dashboard'
# end

# get '/api/:api_key/create-event$:opts' do
#   valid_key = ApiKey.first(api_key: params[:api_key])
#   if !valid_key.nil?
#     User.all.to_json(only: [:id, :username, :email])
#     opts_str = params[:opts].to_s
#     opts = opts_str.split "&"
#     opts.each_with_index.map{|opt, i|
#       kv = opt.split "="
#     opts[i] = [kv[0], kv[1]]}
#     event = Event.new
#     opts.each do |opt|
#       event[opt[0]] = opt[1]
#       p event[opt[0]]
#     end
#     event.user = User.first
#     if event.save
#       event.to_json
#     else
#       "BAD ENTRY"
#     end
#   end
# end