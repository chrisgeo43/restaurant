class Party < ActiveRecord::Base
	# has_many Meals
	has_many :foods, through: :orders
	has_many :orders
end






# CREATE TABLE parties (
# id SERIAL PRIMARY KEY,
# party_name TEXT NOT NULL,
# party_size INT NOT NULL,
# table_number INT NOT NULL,
# meal_paid BOOLEAN NOT NULL,
# created_at TIMESTAMP NOT NULL,
# updated_at TIMESTAMP NOT NULL);
