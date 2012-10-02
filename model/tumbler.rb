require 'data_mapper'

class Tumbler
	include DataMapper::Resource
	property :id, 			Serial
end