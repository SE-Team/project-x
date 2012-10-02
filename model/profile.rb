require 'data_mapper'

class Profile
	include DataMapper::Resource
	property :id,		Serial
	property :first_name, String
	property :last_name, String
	property :age, 		Integer
	property :gender,	String
	property :bio,		Text
end