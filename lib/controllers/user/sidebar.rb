module UserSidebarController
	def user_sidebar_items(user)
	  [{href: "/user/#{user.user_name}/dashboard", icon: "icon-home", title: "Stream"},
	   {href: "/popular", icon: "icon-fire", title: "Popular Events"},
	   {href: "/upcoming", icon: "icon-play-circle", title: "Upcoming Events"},
	   {href: "/newest", icon: "icon-leaf", title: "Newest Events"},
	   {href: "/user/#{user.user_name}/following", icon: "icon-tag", title: "Following", badge: {value: "#{user.followed_people.count}"}},
	   {href: "/user/#{user.user_name}/followers", icon: "icon-tags", title: "Followers", badge: {value: "#{user.followers.count}"}}]
	end

	def user_sidebar(user)
	  @map = {title: user.user_name,
	          items: user_sidebar_items(user)}
	  @sidebar = partial(:'user/sidebar', {map: @map})
	end
end
