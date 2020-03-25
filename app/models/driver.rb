class Driver < ApplicationRecord

	has_one  :user
	has_many :vehicles, dependent: :destroy
	has_many :reviews, dependent: :destroy
	has_many :routes
	has_many :ratings, dependent: :destroy
end
