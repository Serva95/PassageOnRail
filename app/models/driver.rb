class Driver < ApplicationRecord
	validates :email, presence: true, uniqueness: true


	has_many :vehicles, dependent: :destroy
	has_many :reviews
	has_many :routes
	has_many :ratings
	has_many :chats
end
