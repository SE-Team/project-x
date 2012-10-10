path = File.expand_path("../", __FILE__)

require 'rubygems'
require 'sinatra'
require "#{path}/lib/app"

run Sinatra::Application