class ChangeMultiTripAssociations < ActiveRecord::Migration[6.0]
  def change
    remove_column :multi_trip_associations, :tempo_t, :datetime
    remove_column :multi_trip_associations, :prezzo_t, :float
    remove_column :multi_trip_associations, :posti_prenotati, :integer
    remove_column :multi_trip_associations, :user_id, :integer
    remove_column :multi_trip_associations, :route_id2, :integer
    rename_table :multi_trip_associations, :stages
    add_reference :stages, :journey, foreign_key: true
    rename_column :stages, :route_id1, :route_id
  end
end
