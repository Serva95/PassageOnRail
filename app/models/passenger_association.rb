class PassengerAssociation < ApplicationRecord
	belongs_to :single_trip
	belongs_to :hitch_hiker
end
