## Google ####################################################
# require 'picasa'
require 'google/api_client'
require 'yaml'

require './lib/util/util'
##############################################################

module OAuthController
	def api_config
	    @settings ||= (begin
	    	settings = YAML::load(File.open('lib/config/config.yml'))
	      	settings
	    end)
	end

	def api_get_client(code="")
	  	@client ||= (begin
			config_info = api_config
			client = Google::APIClient.new
			client.authorization.client_id = get_in(config_info, ["google_api", "dev", "client_id"])
			client.authorization.client_secret = get_in(config_info, ["google_api", "dev", "client_secret"])
			client.authorization.scope = get_in(config_info, ["google_api", "dev", "scope"]).join(' ')
			client.authorization.redirect_uri = get_in(config_info, ["google_api", "dev", "registered_redirect_uri"])
			client.authorization.code = code
			# logger.debug session.inspect
			if session[:token_id]
				# Load the access token here if it's available
				token_pair = TokenPair.get(session[:token_id])
				client.authorization.update_token!(token_pair.to_hash)
			end
			if client.authorization.refresh_token && client.authorization.expired?
				client.authorization.fetch_access_token!
			end
			unless client.authorization.access_token || request.path_info =~ /^\/oauth2/
				redirect to('/oauth2authorize')
			end
		@client
	  end)
	end


end
