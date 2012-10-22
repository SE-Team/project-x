module UserSidebarController
	def user_sidebar_items(user)
	  [{href: "/user/#{user.user_name}/stream", icon: "icon-th", title: "Stream"},
	   {href: "/user/#{user.user_name}/events", icon: "icon-home", title: "Events", badge: {value: "#{user.events.all.count}"}},
	   {href: "/user/#{user.user_name}/messages", icon: "icon-envelope", title: "Messages", badge: {value: "#{user.r_messages.all(new_message: true).count}"}},
	   :divider,
	   {href: "/user/#{user.user_name}/friends", icon: "icon-user", title: "Friends"},
	   {href: "/user/#{user.user_name}/following", icon: "icon-tag", title: "Following", badge: {value: "#{user.followed_people.count}"}},
	   {href: "/user/#{user.user_name}/followers", icon: "icon-tags", title: "Followers", badge: {value: "#{user.followers.count}"}},
	   :divider,
	   {href: "/user/#{user.user_name}/create-event", icon: "icon-flag", title: "Create Event"},
	   {href: "/search/", icon: "icon-search", title: "Search"},
	   {href: "/user/#{user.user_name}/picasa/", icon: "icon-picture", title: "Picasa"},
	   :divider,
	   {href: "/user/#{user.user_name}/account", icon:  "icon-pencil", title: "Settings"},
	   {href: "/logout", icon: "icon-off", title: "Logout"}]
	end

	def user_sidebar(user)
	  @map = {title: user.user_name,
	          items: user_sidebar_items(user)}
	  @sidebar = partial(:'user/sidebar', {map: @map})
	end
end
