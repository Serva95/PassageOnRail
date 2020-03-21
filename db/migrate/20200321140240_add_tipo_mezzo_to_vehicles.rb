class AddTipoMezzoToVehicles < ActiveRecord::Migration[6.0]
  def change
  add_column :vehicles, :tipo_mezzo, :varchar
  end
end
