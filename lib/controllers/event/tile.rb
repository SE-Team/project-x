module TileController
	def render_pane(pane_map)
	  partial(:'looking_glass/tile', {map: pane_map})
	end

	def comment_count(event)
		return event.tumbler.comments.count
	end

	## checks if a user has messages and then returns the appropriate class for the count size
	def get_event_value_class(event)
		count = event.tumbler.comments.count
		if count < 9
			return "single-digit-notifier-value"
		elsif count > 9 && count < 100
			return "double-digit-notifier-value"
		else
			return "triple-digit-notifier-value"
		end
	end
end