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
require './controller/form'
##############################################################

## Routes ####################################################
## Requiring the additional routes files will add all of their
## routes to the application. The routes call their own
## controllers and define their own urls. For more information
## on the additinal routes available lookin the files listed
## below which can be found in the routes/ directory.
##############################################################
require './routes/user/user'
require './routes/admin/admin'
require './routes/api/api'
##############################################################

## Google ####################################################
##############################################################
# require 'picasa'
# require 'google/api_client'
##############################################################

##############################################################
### Controller includes ######################################
include Helpers
include FormController
include UserSidebarController
include TileController
##############################################################

##############################################################
### Sinatra Sessions (cookies) ###############################
configure do
  enable :sessions
end
##############################################################

##############################################################
## Splash page ###############################################
get '/' do
  @user = User.first(user_name: session[:user])
  if session[:token_id]
    # if token_pair = TokenPair.first(id: session[:token_id].to_i) 
      # @client.authorization.update_token!(token_pair.to_hash)
    # end
  end
  unless @user == nil
    @user_name = session[:user]
  end
  haml :index
end
##############################################################

get '/about' do
  unless session[:user] == nil
    @user_name = session[:user]
  end
  haml :about
end

get '/contact' do
  haml :contact
end

##############################################################
### Login/Logout #############################################
get '/login' do
  @map = {action: "/login",
          title: "Login"}
  haml :login
end

post '/login' do
    # Create a unique id for this user session
    # make sure the id saved
  if @user = User.authenticate(params["username"], params["password"])
    session[:user] = @user.user_name
    flash("Login successful")
    redirect "/user/" << session[:user] << "/dashboard"
  else
    flash("Login failed - Try again")
    redirect '/login'
  end
end

get '/logout' do
  session[:user] = nil
  flash("Logout successful")
  redirect '/'
end

##############################################################
### Register #################################################
get '/register' do
  haml :register
end

post '/register' do
  u = User.new
  u.user_name =   params[:user_name]
  u.password =    params[:password]
  u.email =       params[:email]

  if u.save
    flash("User created")
    redirect '/login'
  else
    tmp = []
    flash(tmp)
    redirect '/'
    "didn't work"
  end
end
##############################################################
