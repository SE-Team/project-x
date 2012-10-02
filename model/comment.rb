require 'data_mapper'

class Comment
  include DataMapper::Resource
  property :id,         Serial
  property :posted_by,  String
  property :email,      String
  property :url,        String
  property :body,       Text
  property :created_at,       	DateTime, default: DateTime.now
  property :upadted_at,       	DateTime
end