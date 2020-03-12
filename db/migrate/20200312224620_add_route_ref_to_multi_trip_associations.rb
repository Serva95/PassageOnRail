class AddRouteRefToMultiTripAssociations < ActiveRecord::Migration[6.0]
  def change
    add_reference :multi_trip_associations, :route, foreign_key: true
  end
end
