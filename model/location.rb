require 'dm-core'

class Location
	include DataMapper::Resource
	property :id,       	Serial
	property :city,			String
	property :country,		String
	property :geo_location, String
	property :updated_at, 	DateTime
	property :created_at, 	DateTime, default: DateTime.now  # A DateTime, for any date you might like.
end