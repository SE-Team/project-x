
def api_client code=""
  @client ||= (begin
      config_info = api_config
      client = Google::APIClient.new
      client.authorization.client_id = get_in(config_info, ["google_api", "dev", "client_id"])
      client.authorization.client_secret = get_in(config_info, ["google_api", "dev", "client_secret"])
      client.authorization.scope = get_in(config_info, ["google_api", "dev", "scope"]).join(' ')
      client.authorization.redirect_uri = get_in(config_info, ["google_api", "dev", "registered_redirect_uri"])
      client.authorization.code = code
      
      # temporary
      session[:token_id] = nil

      if session[:token_id]
        # Load the access token here if it's available
        token_pair = TokenPair.get(session[:token_id])
        client.authorization.update_token!(token_pair.to_hash)
      end
      if client.authorization.refresh_token && client.authorization.expired?
        puts client.authorization.fetch_access_token!
      end
      client
  end)
end

get '/oauth2authorize' do
  redirect api_client.authorization.authorization_uri.to_s, 303
end

get '/oauth2callback' do
  code = params[:code]
  client = api_client code
  client.authorization.fetch_access_token!
  # Persist the token here
  token_pair = if session[:token_id]
    TokenPair.get(session[:token_id])
  else
    TokenPair.new
  end
  token_pair.update_token!(@client.authorization)
  token_pair.save
  session[:token_id] = token_pair.id

  if response = open("https://www.googleapis.com/oauth2/v1/userinfo?access_token=#{token_pair.access_token}").read
    r_hash = JSON.parse(response)
    email = r_hash["email"]
    user = User.first(user_name: email)
    if user
      # session[:token_id] = token_pair.id
      session[:user] = user.user_name
      redirect to("/user/#{user.user_name}/dashboard")
    else
      user = User.create(user_name: email, email: email, token_pair: token_pair)
      # session[:token_pair_id] = token_pair.id
      session[:user] = user.user_name
      redirect to("/user/#{user.user_name}/dashboard")
    end
  end
  # session[:token_id] = nil
  redirect to('/')
end

get '/user/:user_name/picasa/' do
  @user = User.first(user_name: session[:user])
  client = api_client
end
