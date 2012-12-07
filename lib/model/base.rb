## data-mapper dependency requires
require 'data_mapper'
require 'dm-migrations'

## load project db models
require './lib/model/profile'
require './lib/model/event'
require './lib/model/user'
require './lib/model/comment'
require './lib/model/user/message'
require './lib/model/category'
require './lib/model/categorization'
require './lib/model/admin'
require './lib/model/time'
require './lib/model/oauth/token_pair'
require './lib/model/user/account_setting'
require './lib/model/tumbler'
require './lib/model/meta_data'
require './lib/model/apikey'

require './lib/model/data_generator'

# DataMapper::Logger.new(STDOUT, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/lib/db/base.db")
DataMapper::Model.raise_on_save_failure = true
# Now we re-open our Event and Categories classes to define associations
class User
  has n, :events
  has 1, :profile

  has n, :s_messages
  has n, :r_messages

  def followers
    Link.all(followed: self).map {|l| l.follower}
  end

  def following
    Link.all(follower: self).map {|l| l.followed}
  end

  # Follow one or more other people
  def follow(user)
    link = User::Link.create(follower: self, followed: user)
    link
  end

  # Unfollow one or more other people
  def unfollow(user)
    User::Link.all(:followed_id => user.id, :follower_id => self.id).destroy!
    response = reload
  end

  def following?(user)
    following.map{|u| u.user_name}.include?(user.user_name)
  end

  def followed_by?(user)
    followers.map{|u| u.user_name}.include?(user.user_name)
  end

  has n, :friendships, :child_key => [:source_id]


  has n, :friends, self, :through => :friendships, :via => :target

  # Acount settings
  has 1, :account_setting
  after :create, :init_account_settings

  def init_account_settings
    account_setting = AccountSetting.create(user: self)
    account_setting.save
  end
end

class Profile
  belongs_to :user
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
  belongs_to :event, key: true
  # belongs_to :metadata
end

class Comment
  belongs_to :tumbler, key: true
end

# class Metadata
#   has 1, :tumbler
# end

class Event
  belongs_to :user
  has n, :times
  has 1, :tumbler
  has 1, :category
  after :create, :init_meta

  def init_meta
    self.tumbler = Tumbler.create(event: self)
    if self.category.nil?
        category = Category.create(name: "etc", event: self)
        category.save
    end
  end
end

class Metadata
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
  dg.rand_followships
  print "."
  dg.rand_events 100
  print "."
  dg.rand_comments
  print "."
  dg.rand_messages
  print "."
  puts "Createing admin account"
  admin = Admin.first_or_create(user_name: "admin", password: "*Project-X*", email: "admin@project-x.com")
  puts "Finished generating user data and admin account"
end
