class CreateRoutes < ActiveRecord::Migration[6.0]
  def change
    create_table :routes do |t|
      t.string :citta_partenza
      t.string :luogo_ritrovo
      t.datetime :data_ora_partenza
      t.string :citta_arrivo
      t.datetime :data_ora_arrivo
      t.float :costo
      t.boolean :deleted

      t.timestamps
    end
  end
end
