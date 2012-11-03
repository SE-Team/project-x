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

before do
  # Make sure access token is up to date for each request
  SessionController.get_client(session[:user_uuid]).authorization.update_token!(session)
  if SessionController.get_client(session[:user_uuid]).authorization.refresh_token &&
      SessionController.get_client(session[:user_uuid]).authorization.expired?
    SessionController.get_client(session[:user_uuid]).authorization.fetch_access_token!
  end
end

after do
  # Serialize the access/refresh token to the session
  session[:access_token] = SessionController.get_client(session[:user_uuid]).authorization.access_token
  session[:refresh_token] = SessionController.get_client(session[:user_uuid]).authorization.refresh_token
  session[:expires_in] = SessionController.get_client(session[:user_uuid]).authorization.expires_in
  session[:issued_at] = SessionController.get_client(session[:user_uuid]).authorization.issued_at
end


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
      SessionController.remove(session[:user_uuid])
      redirect to("/")
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
get '/user/:user_name/drive' do
  @drive = SessionController.drive(session[:user_uuid]  )
  @client = SessionController.get_client(session[:user_uuid])
  result = @client.execute(:api_method => @drive.files.list,
                           :parameters => {})
  result.data.to_json
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
post '/:user_email/sync/add/:event_id' do
   event = Event.get(params[:event_id])
   user = params[:user_email]
   pp event
   g_event = {
      "start" => {
         "date" => "2012-11-5"
      },
      "end" => {
         "date" => "2012-11-8"
      },
      "location" => event[:location],
      "transparency" => "transparent",
      "description" => event[:body],
      "summary" => event[:title],
      "status" => "confirmed"
   }
   service = SessionController.calendar(session[:user_uuid])
   client = SessionController.get_client(session[:user_uuid])
   if !event[:google_cal_id]
      result = client.execute(:api_method => service.events.insert,
                              :parameters => {'calendarId' => user},
                              :body => JSON.dump(g_event),
                              :headers => {'Content-Type' => 'application/json'})
      event.attributes= {:google_cal_id => result.data.id}
      event.save
   else
      result = client.execute(:api_method => service.events.get,
                        :parameters => {'calendarId' => user, 'eventId' => event[:google_cal_id]})
      event = result.data
      if event.status = "cancelled"
         event.status = "confirmed"
         result = client.execute(:api_method => service.events.update,
                                 :parameters => {'eventId' => event.id, 'calendarId' => user},
                                 :body_object => event,
                                 :headers => {'Content-Type' => 'application/json'})
      end
   end
end

################################################################################
# INFO and Helpers
################################################################################
# in irb
# list API methods:
# client.discovered_apis
# client.discovered_apis.each{|api| puts "name: #{api.name}, title: #{api.title}, version: #{api.version}"}
