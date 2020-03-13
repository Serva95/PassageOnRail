class MultiTripAssociation < ApplicationRecord
  belongs_to :route
  belongs_to :multi_trip
end
