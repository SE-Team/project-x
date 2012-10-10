module BreadCrumbsController
	def bread_crumbs_partial(crumbs_arr)
		partial(:'elements/bread_crumbs', {crumbs: crumbs_arr})
	end
end