require 'rubygems'
require 'bundler'
Bundler.require

if ENV['APP_ENV'] == 'production'
	ActiveRecord::Base.establish_connection({
		adapter: 'postgresql',
		database: 'restaurant_crud'
	})
else
	ActiveRecord::Base.establish_connection({
		adapter: 'postgresql',
		database: 'restaurant_crud',
		host: "localhost", 
		port: 5432
	})
end


['models/concerns', 'models', 'controllers'].each do |component|
  Dir["#{component}/*.rb"].sort.each do |file|
    require File.expand_path(file)
  end
end