class HitchHiker < ApplicationRecord

	has_one :user
	has_many :reviews
	has_many :ratings
	has_many :passenger_associations
	has_many :routes, :through => :passenger_associations
end
