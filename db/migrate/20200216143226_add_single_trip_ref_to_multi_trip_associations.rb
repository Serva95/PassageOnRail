class AddSingleTripRefToMultiTripAssociations < ActiveRecord::Migration[6.0]
  def change
    add_reference :multi_trip_associations, :single_trip, foreign_key: true
  end
end
