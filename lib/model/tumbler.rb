require 'dm-core'

class Tumbler
	include DataMapper::Resource
	property :id, 			Serial
end