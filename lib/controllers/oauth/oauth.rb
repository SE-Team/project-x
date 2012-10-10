## Google ####################################################
# require 'picasa'
require 'google/api_client'
##############################################################

module OAuthController
	def api_client code=""
	  @client ||= (begin
	      config_info = api_config
	      client = Google::APIClient.new
	      client.authorization.client_id = get_in(config_info, ["google_api", "dev", "client_id"])
	      client.authorization.client_secret = get_in(config_info, ["google_api", "dev", "client_secret"])
	      client.authorization.scope = get_in(config_info, ["google_api", "dev", "scope"]).join(' ')
	      client.authorization.redirect_uri = get_in(config_info, ["google_api", "dev", "registered_redirect_uri"])
	      client.authorization.code = code
	      
	      # temporary
	      session[:token_id] = nil

	      if session[:token_id]
	        # Load the access token here if it's available
	        token_pair = TokenPair.get(session[:token_id])
	        client.authorization.update_token!(token_pair.to_hash)
	      end
	      if client.authorization.refresh_token && client.authorization.expired?
	        puts client.authorization.fetch_access_token!
	      end
	      client
	  end)
	end
end