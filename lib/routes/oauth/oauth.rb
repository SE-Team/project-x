
## Controllers ###############################################
require './lib/controllers/oauth/oauth'
##############################################################

include OAuthController

get '/oauth2authorize' do
  redirect api_client.authorization.authorization_uri.to_s, 303
end

get '/oauth2callback' do
  session[:token_id] = nil
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
      session[:user].user_name = user.user_name
      redirect to("/user/#{user.user_name}/dashboard")
    else
      user = User.create(user_name: email, email: email, token_pair: token_pair)
      # session[:token_pair_id] = token_pair.id
      session[:user].user_name = user.user_name
      redirect to("/user/#{user.user_name}/dashboard")
    end
  end
  # session[:token_id] = nil
  redirect to('/')
end

get '/user/:user_name/picasa/' do
  @user = User.first(user_name: session[:user].user_name)
  client = api_client
end