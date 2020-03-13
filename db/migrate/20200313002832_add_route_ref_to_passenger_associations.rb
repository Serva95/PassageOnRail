class AddRouteRefToPassengerAssociations < ActiveRecord::Migration[6.0]
  def change
    add_reference :passenger_associations, :route, foreign_key: true
  end
end
