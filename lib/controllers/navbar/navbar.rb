module NavbarController

	## checks if a user has messages and then returns the appropriate class for the count size
	def get_value_class(user)
		count = session[:user].r_messages.all(new_message: true).count
		if count < 9
			return "single-digit-notifier-value"
		elsif count > 9 && count < 100
			return "double-digit-notifier-value"
		else
			return "triple-digit-notifier-value"
		end
	end

	def notification_count(user)
		count = session[:user].r_messages.all(new_message: true).count
		if count < 99
			return count.to_s
		else
			return "!"
		end
	end

	def needs_notification?(user)
		session[:user].r_messages.all(new_message: true).count > 0
	end
end