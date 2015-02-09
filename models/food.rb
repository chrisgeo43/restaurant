require_relative 'concerns/display_price'

class Food < ActiveRecord::Base
	# has_many Meals
	has_many :orders
	has_many :parties, through: :orders

	validates :name, uniqueness: true
	include DisplayPrice
end




# CREATE TABLE foods (
# id SERIAL PRIMARY KEY,
# name TEXT NOT NULL,
# description TEXT NOT NULL,
# category TEXT NOT NULL,
# price INT NOT NULL,
# created_at TIMESTAMP NOT NULL,
# updated_at TIMESTAMP NOT NULL);