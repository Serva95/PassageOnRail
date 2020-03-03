class CreateMultiTripAssociations < ActiveRecord::Migration[6.0]
  def change
    create_table :multi_trip_associations do |t|

      t.timestamps
    end
  end
end
