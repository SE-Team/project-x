require 'open-uri'
require 'json'
require 'pp'

class TwitterSearchController
	#twitter
	@rsrc_url = "http://search.twitter.com/search.json"

	# helper functions
	def self.get_in(coll, keys)
		cur_coll = coll
		keys.each do |kw|
			cur_coll = cur_coll[kw]
		end
		return cur_coll
	end

	def self.map_to_params(map)
		map[:q] = "%40" + map[:q].to_s if map.has_key?(:q)
		map.to_a.map{|(k, v)| "#{k.to_s}=#{URI.encode(v.to_s)}"}.join '&'
	end

	# Create the properly formated REST url
	def self.build_url(opts)
		return @rsrc_url << "?" << TwitterSearch.map_to_params(opts)
	end

	# Get the JSON data
	def self.get_data(rest_url)
		return open(rest_url)
	end

	def self.parse_data(data)
		return JSON.parse(data)
	end

	def self.search(opts)
		url = TwitterSearch.build_url(opts)
		puts url
		data = TwitterSearch.get_data(url)
		data_s = data.read
		return TwitterSearch.parse_data(data_s)
	end
end