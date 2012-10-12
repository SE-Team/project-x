## Helpers ###################################################
##############################################################
require './lib/helpers/helpers'

## Sinatra/Web################################################
##############################################################
require 'sinatra'
require 'haml'
##############################################################

### Controllers ###############################################
##############################################################
require './lib/controllers/event/twitter_event'
##############################################################

module TwitterEventController
	def render_twitter_pane(pane_map)
	  partial(:'looking_glass/twitter_tile', {map: pane_map})
	end
end