class AddDriverRefToVehicles < ActiveRecord::Migration[6.0]
  def change
    add_reference :vehicles, :driver, foreign_key: true
  end
end
