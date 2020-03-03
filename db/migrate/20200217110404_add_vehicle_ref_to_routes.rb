class AddVehicleRefToRoutes < ActiveRecord::Migration[6.0]
  def change
    add_reference :routes, :vehicle, foreign_key: true
  end
end
