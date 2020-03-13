class CreateSingleTrips < ActiveRecord::Migration[6.0]
  def change
    create_table :single_trips do |t|
      t.integer :n_passeggeri

      t.timestamps
    end
  end
end
