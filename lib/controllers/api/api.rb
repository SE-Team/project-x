module ApiController
	def api_info
	  {title: "API User Info",
	   input_fields: [{name: "email", type: :text, placeholder: "email"}]}
	end

	def api_form
	  {title: "Register for an API key",
	   elements: [api_info],
	   action: "/api-key",
	   method: "post"}
	end
end
