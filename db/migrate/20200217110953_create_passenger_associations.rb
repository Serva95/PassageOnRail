class CreatePassengerAssociations < ActiveRecord::Migration[6.0]
  def change
    create_table :passenger_associations do |t|

      t.timestamps
    end
  end
end
