require 'dm-core'

class TokenPair
  include DataMapper::Resource

  property :id,             Serial, key: true
  property :token_type,     String
  property :refresh_token,  Text
  property :access_token,   Text
  property :id_token,       Text
  property :expires_in,     Integer
  property :issued_at,      Integer

  def update_token!(object)
    self.refresh_token = object.refresh_token
    self.access_token = object.access_token
    self.expires_in = object.expires_in
    self.issued_at = object.issued_at
  end

  def to_hash
    return {
      :refresh_token => refresh_token,
      :access_token => access_token,
      :expires_in => expires_in,
      :id_token => id_token,
      :issued_at => Time.at(issued_at)
    }
  end
end