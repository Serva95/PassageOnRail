class AddEmailToDrivers < ActiveRecord::Migration[6.0]
  def change
    add_column :drivers, :email, :string
  end
end
