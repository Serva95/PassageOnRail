class MultiTripAssociation < ApplicationRecord
  belongs_to :route, dependent: :destroy
  belongs_to :multi_trip, dependent: :destroy
end
