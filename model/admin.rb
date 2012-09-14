require 'dm-core'

def random_string(len)
	chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
	str = ""
	1.upto(len) { |i| str << chars[rand(chars.size-1)] }
	return str
end

class Admin
	include DataMapper::Resource

	property :id, 		Serial
	property :user_name,        	String, key: true, length: (3..40), required: true
	property :email,            	String, required: true
	property :password,         	String
	property :salt,             	String
	property :hashed_password,  	String
	property :created_at,       	DateTime, default: DateTime.now
	property :upadted_at,       	DateTime
	property :access_level, Integer
	
	def username= new_username
		@username = new_username.downcase
	end

	def password=(pass)
		@password = pass
		self.salt = random_string(10) unless self.salt
		self.hashed_password = Admin.encrypt(@password, self.salt)
	end

	def self.encrypt(pass, salt)
		Digest::SHA1.hexdigest(pass + salt)
	end

	def self.authenticate(login, pass)
		u = Admin.first(user_name: login)
		return nil if u.nil?
		return u if Admin.encrypt(pass, u.salt) == u.hashed_password
		nil
	end
end
