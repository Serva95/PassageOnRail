class AddIndexToPassengerAssociations < ActiveRecord::Migration[6.0]
  def change
    add_index :passenger_associations, [:route_id, :user_id], unique: true
  end
end
