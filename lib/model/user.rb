require 'data_mapper'



class User
  class Link  #from http://datamapper.org/docs/associations.html
    include DataMapper::Resource

    storage_names[:default] = 'user_links'

    # the user who is following someone
    belongs_to :follower, 'User', :key => true

    # the user who is followed by someone
    belongs_to :followed, 'User', :key => true
  end

  include DataMapper::Resource
  property :id,                   Serial
  property :user_name,            String, key: true, length: (3..40), required: true
  property :img_url,              String
  property :email,                String
  property :password,             String
  property :salt,                 String
  property :session_id,           String
  property :hashed_password,      String
  property :created_at,           DateTime, default: DateTime.now
  property :upadted_at,           DateTime
  property :last_stream_request,  DateTime

  def username= new_username
    @username = new_username.downcase
  end

  def password=(pass)
    @password = pass
    self.salt = User.random_string(10) unless self.salt
    self.hashed_password = User.encrypt(@password, self.salt)
  end

  def to_hash
    return {id: self.id,
            user_name: self.user_name,
            img_url: self.img_url,
            email: self.email,
            session_id: self.session_id,
            created_at: self.created_at,
            upadted_at: self.upadted_at,
            last_stream_request: self.last_stream_request}
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

  def self.random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    str = ""
    1.upto(len) { |i| str << chars[rand(chars.size-1)] }
    return str
  end

  def stream_events(args=100)
    events = nil
    if args.class == Range
      events = Event.all(Event.tumbler.comments.posted_by => @user_name)
      return events(limit: args)
    elsif args.class == Fixnum
      events = Event.all(Event.tumbler.comments.posted_by => @user_name)
      return events(limit: args)
    elsif args.class == Hash
      return events = Event.all(args)
    end
    events = self.events if events.count == 0
    return events
  end
end
