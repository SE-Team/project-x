path = File.expand_path("../", __FILE__)

require 'thin'
require "#{path}/app"

run Sinatra::Application