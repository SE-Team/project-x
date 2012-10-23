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

## Controllers ###############################################
##############################################################
require './lib/controllers/form'
require './lib/controllers/user/sidebar'
require './lib/controllers/event/tile'
##############################################################

##############################################################
### Controller includes ######################################
include Helpers
include FormController
include UserSidebarController
include TileController
##############################################################

## Login/Logout ##############################################
##############################################################
get '/admin/login' do
  @map = {action: "/admin/login",
          title: "Admin Login"}
  haml :login
end

post '/admin/login' do
  if @user = Admin.authenticate(params["username"], params["password"])
    SessionController.get(session[:user_uuid]).user_name = @user.user_name
    flash("Admin login successful")
    redirect "/admin/" << SessionController.get(session[:user_uuid]).user_name << "/dashboard"
  else
    flash("Admin login failed - Try again")
    redirect '/admin/login'
  end
end
##############################################################

## Account ###################################################
##############################################################
get '/admin/:admin_user/dashboard' do
  @admin = Admin.first(user_name: SessionController.get(session[:user_uuid]).user_name)
  @users = User.all
  @content = partial(:'admin/dashboard', {admin: @admin, users: @users, api_keys: ApiKey.all})
  @items = [{href: "#", icon: "icon-home", title: "Dashboard"},
            {href: "#", icon: "icon-envelope", title: "Messages", badge: {value: rand(100)}},
            {href: "#", icon: "icon-comment", title: "Comments", badge: {value: rand(100)}},
            {href: "#", icon: "icon-user", title: "Members"},
            :divider,
            {href: "#", icon: "icon-wrench", title: "Settings"},
            {href: "#", icon: "icon-share", title: "Logout"}]
  @map = {title: "Admin",
          items: @items}
  @sidebar = partial(:'admin/sidebar', {map: @map})
  haml :with_sidebar
end
##############################################################
