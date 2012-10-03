require 'dm-core'

class Category
  include DataMapper::Resource
  property :id,         Serial
  property :name,       String
end