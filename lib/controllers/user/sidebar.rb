module UserSidebarController
	def user_sidebar_items(user)
      [{href: "/user/#{user.user_name}/create-event", icon: "icon-flag", title: "Create Event"},
      :divider,
	   {href: "/user/#{user.user_name}/events", icon: "icon-home", title: "My Events", badge: {value: "#{user.events.all.count}"}},
	   {href: "/user/#{user.user_name}/messages", icon: "icon-envelope", title: "Messages", badge: {value: "#{user.r_messages.all(new_message: true).count}"}},
	   :divider,
	   {href: "/user/#{user.user_name}/following", icon: "icon-tag", title: "Following", badge: {value: "#{user.following.count}"}},
	   {href: "/user/#{user.user_name}/followers", icon: "icon-tags", title: "Followers", badge: {value: "#{user.followers.count}"}}]
	end

	def user_sidebar(user)
	  @map = {
            #title: current_user.user_name,
	          items: user_sidebar_items(current_user)}
	  @sidebar = partial(:'user/sidebar', {map: @map})
	end
end
