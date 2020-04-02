class AddDetailsToMultiTripAssociations < ActiveRecord::Migration[6.0]
  def change
    rename_column :multi_trip_associations, :route_id, :route_id1
    add_column :multi_trip_associations, :route_id2, :integer
    add_foreign_key :multi_trip_associations, :routes, column: :route_id2
    add_reference :multi_trip_associations, :user, foreign_key: true
    add_column :multi_trip_associations, :posti_prenotati, :integer
    add_column :multi_trip_associations, :prezzo_t, :float
    add_column :multi_trip_associations, :tempo_t, :datetime
  end
end
