## data-mapper dependency requires
require 'dm-core'
require 'dm-migrations'

## load project db models
require './model/profile'
require './model/event'
require './model/user'
require './model/comment'
require './model/user/message'
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

  has n, :s_messages
  has n, :r_messages

  # If we want to know all the people that John follows, we need to look
  # at every 'Link' where John is a :follower. Knowing these, we know all
  # the people that are :followed by John.
  #
  # If we want to know all the people that follow Jane, we need to look
  # at every 'Link' where Jane is :followed. Knowing these, we know all
  # the people that are a :follower of Jane.
  #
  # This means that we need to establish two different relationships to
  # the 'Link' model. One where the user's role is :follower and one
  # where the user's role is to be :followed by someone.

  # In this relationship, the user is the follower
  has n, :links_to_followed_people, 'User::Link', :child_key => [:follower_id]

  # # In this relationship, the user is the one followed by someone
  has n, :links_to_followers, 'User::Link', :child_key => [:followed_id]

  # # We can then use these two relationships to relate any user to
  # # either the people followed by the user, or to the people this
  # # user follows.

  # # Every 'Link' where John is a :follower points to a user that
  # # is followed by John.
  has n, :followed_people, self,
    :through => :links_to_followed_people, # The user is a follower
    :via     => :followed

  # # Every 'Link' where Jane is :followed points to a user that
  # # is one of Jane's followers.
  has n, :followers, self,
    :through => :links_to_followers, # The user is followed by someone
    :via     => :follower

  # Follow one or more other people
  def follow(others)
    # followed_people.concat(Array(others))
    followed_people.concat(Array(others))
    response = save
    puts "follow sucess = " << response.to_s
    self
  end

  # Unfollow one or more other people
  def unfollow(others)
    links_to_followed_people.all(:followed => Array(others)).destroy!
    response = reload
    puts "unfollow sucess = " << response.to_s
    self
  end

  has n, :friendships, :child_key => [:source_id]

  # We name the relationship :friends cause that's the original intention
  #
  # The target model of this relationship will be the User model as well,
  # so we can just pass self where DataMapper expects the target model
  # You can also use User or 'User' in place of self here. If you're
  # constructing the options programmatically, you might even want to pass
  # the target model using the :model option instead of the 3rd parameter.
  #
  # We "go through" the :friendship relationship in order to get at the actual
  # friends. Since we named our relationship :friends, DataMapper assumes
  # that the Friendship model contains a :friend relationship. Since this
  # is not the case in our example, because we've named the relationship
  # pointing to the actual friend User :target, we have to tell DataMapper
  # to use that relationship instead, when looking for the relationship to
  # piggy back on. We do so by passing the :via option with our :target

  has n, :friends, self, :through => :friendships, :via => :target

  # Acount settings
  has 1, :account_setting
  after :create, :init_account_settings

  def init_account_settings
    account_setting = AccountSetting.create(user: self)
    account_setting.save
  end
end

class Friendship
  include DataMapper::Resource
  belongs_to :source, 'User', :key => true
  belongs_to :target, 'User', :key => true

  after :create, :init_target

  def init_target
    f = Friendship.first_or_create(target: self.source, source: self.target)
    f.user_user_name = self.target.user_name
    f.save
  end
end

class RMessage
  belongs_to :user, key: true
end

class SMessage
  belongs_to :user, key: true
end

class AccountSetting
  belongs_to :user
end

class Category
  belongs_to :event

  # def name=(n)
  #   @name = n
  #   event.category_name  = n
  # end
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
    tumbler = Tumbler.create(metadata: self.metadata)
    if self.category.nil?
        category = Category.create(name: "etc", event: self)
        category.save
    end
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

# if User.all.count == 0
  puts "Generate user data"
  dg = DataGenerator.new
  print "."
  dg.rand_users
  print "."
  dg.rand_events
  print "."
  dg.rand_comments
  print "."
  dg.rand_messages
  print "."
  puts "Createing admin account"
  admin = Admin.first_or_create(user_name: "admin", password: "*Project-X*", email: "admin@project-x.com")
  puts "Finished generating user data and admin account"
# end
