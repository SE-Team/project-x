## Google ####################################################
# require 'picasa'
require 'google/api_client'
##############################################################

module OAuthController
	def api_config
	    @settings ||= (begin
	    	settings = YAML::load(File.open('lib/config/config.yml'))
	      	settings
	    end)
	end

	def api_client code=""
	  	@client ||= (begin
			config_info = api_config
			client = Google::APIClient.new
			client.authorization.client_id = get_in(config_info, ["google_api", "dev", "client_id"])
			client.authorization.client_secret = get_in(config_info, ["google_api", "dev", "client_secret"])
			client.authorization.scope = get_in(config_info, ["google_api", "dev", "scope"]).join(' ')
			client.authorization.redirect_uri = get_in(config_info, ["google_api", "dev", "registered_redirect_uri"])
			client.authorization.code = code
			client
	  end)
	end
end