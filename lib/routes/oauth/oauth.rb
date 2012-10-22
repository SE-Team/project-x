##############################################################
## Controllers ###############################################
##############################################################
require './lib/controllers/oauth/oauth'
##############################################################
## Logging ###################################################
##############################################################
require 'logger'
##############################################################

##############################################################
## Controllers ###############################################
##############################################################
include OAuthController
##############################################################

##############################################################
## Logging configuration #####################################
##############################################################
configure do
  log_file = File.open('calendar.log', 'a+')
  log_file.sync = true
  logger = Logger.new(log_file)
  logger.level = Logger::DEBUG
  set :logger, logger
end
##############################################################

##############################################################
## Routes  ###################################################
##############################################################

##############################################################
## Authorization Request #####################################
##############################################################
get '/oauth2authorize' do
  redirect api_client.authorization.authorization_uri.to_s, 303
end
##############################################################

##############################################################
## Google OAuth Callback #####################################
##############################################################
get '/oauth2callback' do
  code = params[:code]
  client = api_client code
  if session[:token_id]
    # Load the access token here if it's available
    token_pair = TokenPair.get(session[:token_id])
    client.authorization.update_token!(token_pair.to_hash)
  end
  if client.authorization.refresh_token && client.authorization.expired?
    client.authorization.fetch_access_token!
  end
  # @calendar = client.discovered_api('calendar', 'v3')
  unless client.authorization.access_token || request.path_info =~ /^\/oauth2/
    redirect to('/oauth2authorize')
  end
  # client.authorization.fetch_access_token!
  #
  # Persist the token here
  token_pair = if session[:token_id]
    TokenPair.get(session[:token_id])
  else
    TokenPair.new
  end
  token_pair.update_token!(client.authorization)
  token_pair.save
  # puts token_pair.issued_at
  # puts "issued at: " + Time.at(token_pair.issued_at)
  session[:token_id] = token_pair.id
  # puts "token id " << session[:token_id].to_s
  if response = open("https://www.googleapis.com/oauth2/v1/userinfo?access_token=#{token_pair.access_token}").read
    r_hash = JSON.parse(response)
    email = r_hash["email"]
    user = User.first(user_name: email, email: email)
    if user
      session[:user] = user
      redirect to("/user/#{user.user_name}/dashboard")
    else
      redirect to("/user/#{user.user_name}/dashboard")
    end
  end
  # puts "token id " << session[:token_id].to_s
  redirect to('/')
end

##############################################################
## API Specific Routes #######################################
##############################################################


##############################################################
## Picasa ####################################################
## scope: https://picasaweb.google.com/data/ #################
##############################################################
get '/user/:user_name/picasa/' do
  @user = User.first(user_name: session[:user].user_name)
  client = api_client
end
##############################################################


##############################################################
## Google Calendar ###########################################
## scope: https://www.googleapis.com/auth/calendar ###########
##############################################################
get '/user/:user_name/test/google-calendar' do
    base_url = "https://www.googleapis.com/calendar/v3"
    puts session[:token_id]
    token_pair = TokenPair.get(session[:token_id])
    puts token_pair
    calendar_api_url = base_url + "/users/#{session[:user].user_name}/calendarList" + "?access_token=#{token_pair.access_token}"
    puts calendar_api_url
    response = open(calendar_api_url).read
    r_hash = JSON.parse(response)
end
##############################################################
