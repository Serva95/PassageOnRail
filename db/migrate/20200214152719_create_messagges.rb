class CreateMessagges < ActiveRecord::Migration[6.0]
  def change
    create_table :messagges do |t|
      t.datetime :data_ora
      t.text :testo
      t.string :mittente
      t.string :destinatario

      t.timestamps
    end
  end
end
