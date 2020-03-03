class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :password
      t.string :nome
      t.string :cognome
      t.date :data_di_nascita
      t.string :cellulare
      t.text :indirizzo
      t.string :url_foto
      t.boolean :deleted

      t.timestamps
    end
  end
end
