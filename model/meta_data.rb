require 'dm-core'

class Metadata
	include DataMapper::Resource
	property :id,			Serial
	property :created_at, 	DateTime
	property :updated_at, 	DateTime
end