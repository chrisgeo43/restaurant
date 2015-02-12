require './app.rb'
require_relative 'environment'

require 'bundler'
Bundler.require :default

map('/foods') { run FoodsController }
map('/parties') { run PartiesController }
map('/orders') { run OrdersController }
run Sinatra::Application