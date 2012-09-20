require 'dm-core'

class AccountSetting
	include DataMapper::Resource
	property :id, 		Serial
	property :categories, String, default: ""
end