require 'data_mapper'
require './lib/controllers/session/session_controller'

require 'pp'


class Event
	include DataMapper::Resource
	property :id,         		Serial 	# An auto-increment integer key
	property :title,      		String 	# A varchar type string, for short strings
	property :permission, 		String, 	default: "public"
	property :event_date, 		DateTime, 	default: DateTime.now
	property :category_name, 	String, 	default: ""
	property :updated_at, 		DateTime
	property :created_at, 		DateTime, 	default: DateTime.now  # A DateTime, for any date you might like.
	property :body,       		Text  	# A text block, for longer string data.
	property :img_url,    		String
	property :video_url,    	String
	property :google_calendar_id,	String

	after :update, :update_time

	def update_time
		@updated_at = DateTime.now
	end

	def toggle_google_calendar_event(user_uuid)
		success = false
		return_msg = ""
		if self.user == user
			service = SessionController.calendar(user_uuid)
			client = SessionController.get_client(user_uuid)
			result = nil
			if google_calendar_id
			 	result = client.execute(:api_method => service.events.get,
			                    		:parameters => {'calendarId' => user.email,
			                    			 			'eventId' => self.google_calendar_id})
			  google_calendar_event = result.data
			 	google_calendar_event.status = "cancelled"
				result = client.execute(:api_method => service.events.delete,
				                        :parameters => {'calendarId' => user.email,
				                        				'eventId' => google_calendar_event.id})
				success = update google_calendar_id: nil
				return_msg = "unsynched"
			else
			  	result = client.execute(:api_method => service.events.insert,
			                          :parameters => {'calendarId' => SessionController.user(user_uuid).email},
			                          :body => JSON.dump(generate_google_event_json("Test Location", self.body, self.title)),
			                          :headers => {'Content-Type' => 'application/json'})
			  	success = update google_calendar_id: result.data.id
				return_msg = "synched"
		  	end
		end
		return success ? return_msg : "failed"
	end

	def generate_google_event_json(location, description, title)
    start_date = "2012-11-5"
    end_date = "2012-11-8"
    {
    	"start" => { "date" => start_date },
	    "end" => { "date" => end_date },
	    "location" => location,
	    "transparency" => "transparent",
	    "description" => body,
	    "summary" => title,
	    "status" => "confirmed"
 	}
	end

end
