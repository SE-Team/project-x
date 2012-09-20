require 'dm-core'

class Event
	include DataMapper::Resource
	property :id,         Serial    # An auto-increment integer key
	property :title,      String    # A varchar type string, for short strings
	property :permission, String
	property :event_date, DateTime, default: DateTime.now
	property :upadted_at, DateTime
	property :created_at, DateTime, default: DateTime.now  # A DateTime, for any date you might like.
	property :body,       Text      # A text block, for longer string data.
	property :img_url,    String
	before :update, :update_update_time

	def update_update_time
		@upadted_at = DateTime.now
	end
end 
