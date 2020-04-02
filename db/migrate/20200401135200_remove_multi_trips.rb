class RemoveMultiTrips < ActiveRecord::Migration[6.0]
  def change
    remove_column :multi_trip_associations, :multi_trip_id, :integer
    drop_table :multi_trips, {:force => :cascade}
  end
end
