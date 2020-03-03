class CreateMultiTrips < ActiveRecord::Migration[6.0]
  def change
    create_table :multi_trips do |t|
      t.datetime :data_ora_partenza
      t.string :citta_partenza
      t.datetime :data_ora_arrivo
      t.string :citta_arrivo
      t.integer :costo_totale
      t.float :comfort_medio
      t.integer :numero_cambi

      t.timestamps
    end
  end
end
