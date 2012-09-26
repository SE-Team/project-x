require 'dm-core'

class SMessage
  include DataMapper::Resource
  property :id, 	Serial
  property :subject, String, default: ""
  property :body, 	Text, default: ""
  property :created_at, DateTime, default: DateTime.now
  property :star, 	Boolean, default: false
  property :sent, Boolean, default: false
  property :reply_id, Integer
  property :target, String

  def send(target_user)
  	msg = RMessage.create(subject: self.subject, body: self.body, user: target_user, source: self.user.user_name)
    success = msg.save
  	if success
  		self.sent = true
      self.target = target_user.user_name
      save
  		return true
  	else
		  return false
    end
  end
end

class RMessage
  include DataMapper::Resource
  property :id, 	Serial
  property :subject, String, default: ""
  property :body, 	Text, default: ""
  property :created_at, DateTime, default: DateTime.now
  property :star, 	Boolean, default: false
  property :source, String
  property :new_message, Boolean, default: true
end
