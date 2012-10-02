require 'data_mapper'

def random_string(len)
	chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
	str = ""
	1.upto(len) { |i| str << chars[rand(chars.size-1)] }
	return str
end

class ApiKey
	include DataMapper::Resource
	property :id, 		Serial
	property :email, 	String, required: true 
	property :api_key, 	String, default: random_string(50)
end