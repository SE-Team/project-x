## data-mapper dependency requires
require 'dm-core'
require 'dm-migrations'

## load project db models
require './model/profile'
require './model/event'
require './model/user'
require './model/comment'
require './model/location'
require './model/category'
require './model/categorization'
require './model/admin'
require './model/time'
require './model/tumbler'
require './model/meta_data'
require './model/apikey'


DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/db/base.db")

# Now we re-open our Event and Categories classes to define associations
class User
	has n, :events
	has 1, :profile
end

class Categorization
	belongs_to :category
	belongs_to :event
end

class Category
	has n, :categorizations
	has n, :events,      :through => :categorizations
end

class Tumbler
	has n, :comments
	belongs_to :metadata
end

class Comment
	belongs_to :tumbler
end

class Metadata
	has 1, :tumbler
end

class Event
	belongs_to :user
	has n, :locations
	has n, :times
	has 1, :metadata
	has n, :categorizations
	has n, :categories, :through => :categorizations

	after :create, :init_meta

	def init_meta
		self.metadata = Metadata.create(event: self)
		tumbled = Tumbler.create(metadata: self.metadata)
	end
end

class Metadata
	belongs_to :event
end

class Location
	belongs_to :event
end

class Time
	belongs_to :event
end

class ApiKey
	has 1, :admin
end

class Admin
	has 1, :api_key

	after :create, :init_apikey

	def init_apikey
		self.api_key = ApiKey.create(admin: self)
	end
end

def get_day(record)
  record.created_at.asctime.slice(0..3)
end

def get_month(creation_date)
  record.created_at.asctime.slice(4..6)
end

DataMapper.auto_upgrade!


if User.all.count == 0 && Admin.all.count == 0
	superman = User.first_or_create(user_name: "superman", password: "pass", email: "superman@superman.com")
	batman = User.first_or_create(user_name: "batman", password: "pass", email: "batman@batman.com")
	spiderman = User.first_or_create(user_name: "spiderman", password: "pass", email: "spiderman@spiderman.com")
	joker = User.first_or_create(user_name: "joker", password: "pass", email: "joker@joker.com")
	bane = User.first_or_create(user_name: "bane", password: "pass", email: "bane@bane.com")
	lex_luther = User.first_or_create(user_name: "lex-luther", password: "pass", email: "lex-luther@lex-luther.com")
	admin = Admin.first_or_create(user_name: "admin", password: "*Project-X*", email: "admin@project-x.com")
end