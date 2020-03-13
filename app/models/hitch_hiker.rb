class HitchHiker < ApplicationRecord

	has_one :user
	has_many :reviews
	has_many :ratings
	has_many :chats
	has_many :passenger_associations
	has_many :single_trips, :through => :passenger_associations
end
