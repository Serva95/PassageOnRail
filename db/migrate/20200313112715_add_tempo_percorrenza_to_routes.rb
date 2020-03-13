class AddTempoPercorrenzaToRoutes < ActiveRecord::Migration[6.0]
  def change
	add_column :routes, :tempo_percorrenza, :integer
  end
end
