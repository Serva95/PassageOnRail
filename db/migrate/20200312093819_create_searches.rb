class CreateSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :searches do |t|
      t.string :c_partenza
      t.string :c_arrivo
      t.datetime :data_ora
      t.float :rating
      t.float :costo
      t.string :tipo_mezzo

      t.timestamps
    end
  end
end
