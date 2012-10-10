require './lib/app'

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'

set :environment, :test

Rspec.configure do |config|
  config.before(:each) { DataMapper.auto_migrate! }
end