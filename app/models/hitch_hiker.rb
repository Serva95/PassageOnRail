class HitchHiker < ApplicationRecord

	has_one :user
	has_many :reviews, dependent: :destroy
	has_many :ratings, dependent: :destroy
	has_many :chats, dependent: :destroy
	has_many :passenger_associations, dependent: :destroy
	has_many :single_trips, :through => :passenger_associations, dependent: :destroy
end
