require './helpers/helpers'
require './helpers/sinatra'
require 'sinatra'
require 'haml'

## DataMapper configuration and models
require './model/base'

## controllers
require './controller/form'
require './controller/user/sidebar'
require './controller/event/tile'


get '/admin/login' do
  @map = {action: "/admin/login",
          title: "Admin Login"}
  haml :login
end

post '/admin/login' do
  if @user = Admin.authenticate(params["username"], params["password"])
    session[:user] = @user.user_name
    flash("Admin login successful")
    redirect "/admin/" << session[:user] << "/dashboard"
  else
    flash("Admin login failed - Try again")
    redirect '/admin/login'
  end
end

get '/admin/:admin_user/dashboard' do
  @admin = Admin.first(user_name: session[:user])
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

get '/util/test.html' do
  partial(:form, {form_map: event_form})
end
