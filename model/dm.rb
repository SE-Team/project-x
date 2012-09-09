require 'dm-core'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-migrations'
require './helpers/helpers'


DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/db/base.db")

class Profile
	include DataMapper::Resource
	property :id,		Serial
	property :first_name, String
	property :last_name, String
	property :age, 		Integer
	property :gender,	String
	property :bio,		Text
	belongs_to :user
end

class User
	include DataMapper::Resource
	property :id,               	Serial
	property :user_name,        	String, key: true, length: (3..40), required: true
	property :img_url,          	String
	property :email,            	String
	property :password,         	String
	property :salt,             	String
	property :hashed_password,  	String
	property :created_at,       	DateTime, default: DateTime.now
	property :upadted_at,       	DateTime

	has 1, :profile

	def username= new_username
		@username = new_username.downcase
	end

	def password=(pass)
		@password = pass
		self.salt = random_string(10) unless self.salt
		self.hashed_password = User.encrypt(@password, self.salt)
	end

	def self.encrypt(pass, salt)
		Digest::SHA1.hexdigest(pass + salt)
	end

	def self.authenticate(login, pass)
		u = User.first(user_name: login)
		return nil if u.nil?
		return u if User.encrypt(pass, u.salt) == u.hashed_password
		nil
	end

	def random_string(len)
		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
		str = ""
		1.upto(len) { |i| str << chars[rand(chars.size-1)] }
		return str
	end
end

class Location
	include DataMapper::Resource
	property :id,       	Serial
	property :city,			String
	property :country,		String
	property :geo_location, String

	property :upadted_at, 	DateTime
	property :created_at, 	DateTime, default: DateTime.now  # A DateTime, for any date you might like.

	belongs_to :event
end

class Time
	include DataMapper::Resource
	property :id,       	Serial
	property :start,		DateTime
	property :end,			DateTime
	property :duration,		String
	property :created_at, 	DateTime, default: DateTime.now  # A DateTime, for any date you might like.
end

class Event
	include DataMapper::Resource
	## who
	belongs_to :user
	## what
	property :id,         Serial    # An auto-increment integer key
	property :title,      String    # A varchar type string, for short strings
	property :permission, String
	property :upadted_at, DateTime
	property :created_at, DateTime, default: DateTime.now  # A DateTime, for any date you might like.
	## Where
	has n, :locations
	## when
	has n, :times
	## why
	property :body,       Text      # A text block, for longer string data.
	property :img_url,    String
	has n, :comments

	before :update, :update_update_time

	def update_update_time
		@upadted_at = DateTime.now
	end
end 

class Time
	belongs_to :event
end

class Comment
  include DataMapper::Resource

  property :id,         Serial
  property :posted_by,  String
  property :email,      String
  property :url,        String
  property :body,       Text
end

class Category
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String
end

class Categorization
	include DataMapper::Resource
	
	property :id,         	Serial
	property :created_at, 	DateTime
	
	belongs_to :category
	belongs_to :event
end

# Now we re-open our Event and Categories classes to define associations
class Event
  has n, :categorizations
  has n, :categories, :through => :categorizations
end

class Category
  has n, :categorizations
  has n, :events,      :through => :categorizations
end

def get_day(record)
  record.created_at.asctime.slice(0..3)
end

def get_month(creation_date)
  record.created_at.asctime.slice(4..6)
end

DataMapper.auto_upgrade!






@new_user = User.create(user_name: "test", 
						email: "test@test-email.com",
						password: "test")


