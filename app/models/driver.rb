class Driver < ApplicationRecord

	has_one  :user
	has_many :vehicles, dependent: :destroy
	has_many :reviews, dependent: :destroy
	has_many :routes, dependent: :destroy
	has_many :ratings, dependent: :destroy
	has_many :chats, dependent: :destroy
end
