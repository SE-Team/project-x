require 'data_mapper'
require './lib/controllers/session/session_controller'

class Event

	include DataMapper::Resource
	property :id,         		Serial 	# An auto-increment integer key
	property :title,      		String, default: "" 	# A varchar type string, for short strings
	property :location, 			String, default: ""
	property :permission, 		String, 	default: "public"
	property :event_date, 		DateTime, 	default: DateTime.now
	property :start_date, 		DateTime, default: DateTime.now
	property :end_date, 			DateTime, default: DateTime.now
	property :synched, 				Boolean, default: false
	property :updated_at, 		DateTime
	property :created_at, 		DateTime, 	default: DateTime.now  # A DateTime, for any date you might like.
	property :body,       		Text  	# A text block, for longer string data.
	property :img_url,    		Text
	property :video_url,    	String
	property :google_calendar_id,	String

	validates_length_of :body, :max => 1000
	#validates_format_of :img_url, :with => /regex/https?:\/\/.*\.(?:png|jpg)

	after :update, :update_time

	# after :create, :clean_title

	def update_time
		@updated_at = DateTime.now
	end

	# def clean_title
	# 	self.title = self.title.downcase
	# end

	# def title
	# 	puts self.title
	# 	self.title.word.split(" ").map{|w| w.capitalize}.join(" ")
	# end

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
				self.synched = false
				return_msg = "unsynched"
			else
			  	result = client.execute(:api_method => service.events.insert,
			                          :parameters => {'calendarId' => SessionController.user(user_uuid).email},
			                          :body => JSON.dump(generate_google_event_json),
			                          :headers => {'Content-Type' => 'application/json'})
			  	success = update google_calendar_id: result.data.id
				self.synched = true
				return_msg = "synched"
		  	end
		end
		return success ? return_msg : "failed"
	end

	def generate_google_event_json
    {
    	"start" => { "date" => self.start_date.strftime("%Y-%m-%d") },
	    "end" => { "date" => self.end_date.strftime("%Y-%m-%d") },
	    "location" => self.location,
	    "transparency" => "transparent",
	    "description" => self.body,
	    "summary" => self.title,
	    "status" => "confirmed"
 		}
	end

end
