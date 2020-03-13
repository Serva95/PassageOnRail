class AddRouteRefToSingleTrips < ActiveRecord::Migration[6.0]
  def change
    add_reference :single_trips, :route, foreign_key: true
  end
end
