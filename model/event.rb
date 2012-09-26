require 'dm-core'

class Event
	include DataMapper::Resource
	property :id,         Serial    # An auto-increment integer key
	property :title,      String    # A varchar type string, for short strings
	property :permission, String, default: "public"
	property :event_date, DateTime, default: DateTime.now
	property :category_name, String, default: ""
	property :updated_at, DateTime
	property :created_at, DateTime, default: DateTime.now  # A DateTime, for any date you might like.
	property :body,       Text      # A text block, for longer string data.
	property :img_url,    String

	after :update, :update_time

	def update_time
		@updated_at = DateTime.now
	end
end 
