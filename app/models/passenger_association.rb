class PassengerAssociation < ApplicationRecord
	belongs_to :route, dependent: :destroy
	belongs_to :hitch_hiker, dependent: :destroy
end
