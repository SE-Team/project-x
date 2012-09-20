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
require './model/user/account_setting'
require './model/tumbler'
require './model/meta_data'
require './model/apikey'

require './model/data_generator'


DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/db/base.db")

# Now we re-open our Event and Categories classes to define associations
class User
	has n, :events
	has 1, :profile
	has 1, :account_setting
end

class AccountSetting
	belongs_to :user
end

class Category
	belongs_to :event
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
	has 1, :category
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

def get_day(record)
  record.created_at.asctime.slice(0..3)
end

def get_month(creation_date)
  record.created_at.asctime.slice(4..6)
end

DataMapper.auto_upgrade!


if User.all.count == 0
	puts "Generate user data"
	dg = DataGenerator.new
	print "."
	dg.rand_users
	print "."
	dg.rand_events
	print "."
	dg.rand_comments
	print "."
	puts "Createing admin account"
	admin = Admin.first_or_create(user_name: "admin", password: "*Project-X*", email: "admin@project-x.com")
	puts "Finished generating user data and admin account"
end