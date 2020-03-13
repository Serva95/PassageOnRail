class PassengerAssociation < ApplicationRecord
	belongs_to :route
	belongs_to :hitch_hiker
end
