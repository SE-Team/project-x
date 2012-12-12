require 'data_mapper'

class TokenPair
  include DataMapper::Resource

  property :id,             Serial
  property :user_name,      String
  property :refresh_token,  String, :length => 255
  property :access_token,   String, :length => 255
  property :expires_in,     Integer
  property :issued_at,      Integer
  property :created_at,     DateTime, default: DateTime.now
  property :updated_at,     DateTime

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
      # :issued_at => Time.at(issued_at),
      :id => id
    }
  end
end