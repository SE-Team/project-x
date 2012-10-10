module TileController
	def render_pane(pane_map)
	  partial(:'looking_glass/tile', {map: pane_map})
	end
end