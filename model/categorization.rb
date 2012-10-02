require 'data_mapper'

class Categorization
	include DataMapper::Resource
	property :id,         	Serial
	property :created_at, 	DateTime
end