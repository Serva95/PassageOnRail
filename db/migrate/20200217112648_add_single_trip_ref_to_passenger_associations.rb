class AddSingleTripRefToPassengerAssociations < ActiveRecord::Migration[6.0]
  def change
    add_reference :passenger_associations, :single_trip, foreign_key: true
  end
end
