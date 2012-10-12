require 'dm-core'

class Categorization
	include DataMapper::Resource
	property :id,         	Serial
	property :created_at, 	DateTime
end