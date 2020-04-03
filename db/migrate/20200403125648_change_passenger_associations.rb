class ChangePassengerAssociations < ActiveRecord::Migration[6.0]
  def change
    remove_column :passenger_associations, :route_id, :integer
    rename_table :passenger_associations, :journeys
  end
end
