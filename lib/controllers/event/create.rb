

module CreateEventController

	def create_event_event_info
	{
		title: "Event Info",
		instr: "Provide a title and body (summary/description) for the event.",
		input_fields:
		[
			{name: "Title", type: :text, autofocus: true, required: "required"},
	    	{name: "Body",  type: :rich_text}
	    ]
	}
	end

	def create_event_time_info
	{
		title: "Time",
		input_fields:
		[
			{name: "Start-Date", type: :date, id: "datepicker"},
	        {name: "Start-Time", type: :text, id: "timepicker"},
	        {name: "End-Date",   type: :date, id: "datepicker"},
	        {name: "End-Time",   type: :text, id: "timepicker"}
		]
	}
	end

	def create_event_location_info
	{
		title: "Location",
	   	input_fields:
	   	[
	   		{type: :text}
	   	]
	}
	end

	def create_event_media_info
	{
		title: "Event Media",
	  	instr: "Specify an absolute URL to embed an image and/or video.",
	   	input_fields:
	   	[
	   		{name: "Image", type: :url, placeholder: "http://www..."},
	        {name: "Video", type: :url, placeholder: "http://www..."}
	    ]
	}
	end

	def create_event_event_form
	{
		title: "Create an Event",
	   	elements:
	   	[
	   		create_event_event_info,
	   		create_event_location_info,
	        create_event_time_info,
	        create_event_media_info
	    ],
	   	action: "/create-event",
	   	method: "post"}
	end

end