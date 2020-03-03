class AddMultiTripRefToMultiTripAssociations < ActiveRecord::Migration[6.0]
  def change
    add_reference :multi_trip_associations, :multi_trip, foreign_key: true
  end
end
