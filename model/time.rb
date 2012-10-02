require 'data_mapper'

class Time
	include DataMapper::Resource
	property :id,       	Serial
	property :start,		DateTime
	property :end,			DateTime
	property :duration,		String
	property :created_at, 	DateTime, default: DateTime.now  # A DateTime, for any date you might like.
end