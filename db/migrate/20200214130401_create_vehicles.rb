class CreateVehicles < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicles do |t|
      t.string :targa
      t.string :marca
      t.string :modello
      t.date :immatricolazione
      t.integer :comfort
      t.integer :posti
      t.boolean :deleted

      t.timestamps
    end
  end
end
