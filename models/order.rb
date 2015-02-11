class Order < ActiveRecord::Base
	belongs_to :party
	belongs_to :food
end

# CREATE TABLE orders (
# id SERIAL PRIMARY KEY,
# party_id INT NOT NULL,
# food_id INT NOT NULL,
# created_at TIMESTAMP NOT NULL,
# updated_at TIMESTAMP NOT NULL);