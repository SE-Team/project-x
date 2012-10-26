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
# include OAuthController
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


get '/login/google' do
  new_uuid = UUID.new.generate
  session[:user_uuid] = new_uuid
  SessionController.add(new_uuid)
  client_access_token = SessionController.fetch_access_token!(new_uuid)
  unless client_access_token || request.path_info =~ /^\/oauth2/
    redirect to('/oauth2authorize')
  end
end

##############################################################
## Authorization Request #####################################
##############################################################
get '/oauth2authorize' do
  redirect SessionController.get_client(session[:user_uuid]).authorization.authorization_uri.to_s, 303
end
##############################################################

##############################################################
## Google OAuth Callback #####################################
##############################################################
get '/oauth2callback' do
  client = SessionController.get_client(session[:user_uuid], params[:code])
  # Persist the token here
  client.authorization.fetch_access_token!
  token_pair = SessionController.token_pair(session[:user_uuid])
  token_pair.update_token!(client.authorization)
  token_pair.save
  if response = open("https://www.googleapis.com/oauth2/v1/userinfo?access_token=#{token_pair.access_token}").read
    r_hash = JSON.parse(response)
    email = r_hash["email"]
    @user = User.first_or_create(user_name: email, email: email)
    if @user
      ## create a new seession user uuid to store the datamapper object
      SessionController.set(session[:user_uuid], @user)
      flash("Login successful")
      redirect to("/user/#{@user.user_name}/stream")
    else
      puts "kill user hash due to bad user creation in oauth2callback"
      SessionController.remove(session[:user_uuid])
      redirect to("/user/#{@user.user_name}/stream")
    end
  end
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
  @picasa = SessionController.picasa(session[:user_uuid])
  @client = SessionController.get_client(session[:user_uuid])
  puts @picasa.methods
  # result = @client.execute(:api_method => @picasa.events.list,
  #                          :parameters => {'calendarId' => 'primary'})
  # result.data.to_json
  "picasa methods" << @picasa.to_s
end
##############################################################


##############################################################
## Google Calendar ###########################################
## scope: https://www.googleapis.com/auth/calendar ###########
##############################################################
get '/user/:user_name/google-calendar' do
  @calendar = SessionController.calendar(session[:user_uuid])
  @client = SessionController.get_client(session[:user_uuid])
  result = @client.execute(:api_method => @calendar.events.list,
                           :parameters => {'calendarId' => 'primary'})
  # status, _, _ = result.response
  # [status, {'Content-Type' => 'application/json'}, result.data.to_json]
  # @picasa = SessionController.picasa(session[:user_uuid])
  # @client = SessionController.get_client(session[:user_uuid])
  # puts @picasa.methods

  result.data.to_json
end
##############################################################
