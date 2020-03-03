class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.datetime :data
      t.integer :rating

      t.timestamps
    end
  end
end
