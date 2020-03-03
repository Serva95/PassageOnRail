class SingleTrip < ApplicationRecord
	validates :n_passeggeri, presence: true
	
	belongs_to :route
	
	has_many :multi_trip_associations
	has_many :multi_trips, :through => :multi_trip_associations
	has_many :passenger_associations
	has_many :hitch_hikers, :through => :passenger_associations
end
