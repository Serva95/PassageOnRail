class RemoveEmailFromDrivers < ActiveRecord::Migration[6.0]
  def change

    remove_column :drivers, :email, :varchar
    remove_column :hitch_hikers, :email, :varchar
    add_reference :users, :driver, foreign_key: true, null: true
    add_reference :users, :hitch_hiker, foreign_key: true,  null: true
  end
end
