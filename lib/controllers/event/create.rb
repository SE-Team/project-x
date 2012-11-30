module CreateEventController
	def create_event_time_info
	  {title: "Time",
	   input_fields: [{name: "start-date", type: :date, placeholder: "start-date"},
	                  {name: "start", type: :text, placeholder: "starting (12:00:00)"},
	                  {name: "end-date", type: :date, placeholder: "end-date"},
	                  {name: "end", type: :text, placeholder: "ending (12:00:00)"}]}
	end

	def create_event_location_info
	  {title: "Location",
	   input_fields: [{name: "location", type: :text, placeholder: "location"}]}
	end

	def create_event_event_info
	  {title: "Event Info",
	   input_fields: [{name: "title", type: :text, placeholder: "title"},
	                  {name: "body", type: :rich_text, placeholder: "body"}]}
	end

	def create_event_media_info
		{title: "Event Media",
  	 instr: "Specify an absolute URL to embed an image and/or video.",
   	 input_fields:
	   	[{name: "image-url", type: :url, placeholder: "image url"},
       {name: "video-url", type: :url, placeholder: "video url"}]}
	end

	def create_event_event_form
	  {title: "Create an Event",
	   elements: [create_event_event_info,
	              create_event_time_info,
	              create_event_location_info,
	              create_event_media_info],
	   action: "/create-event",
	   method: "post"}
	end

end