class CreatePayMethods < ActiveRecord::Migration[6.0]
  def change
    create_table :pay_methods do |t|
      t.string :intestatario, null: false
      t.string :numero, null: false
      t.integer :mese_scadenza, null: false
      t.integer :anno_scadenza, null: false
      t.string :cvv, null: false

      t.timestamps
    end
  end
end
