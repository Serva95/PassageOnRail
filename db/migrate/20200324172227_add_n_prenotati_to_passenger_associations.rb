class AddNPrenotatiToPassengerAssociations < ActiveRecord::Migration[6.0]
  def change
	add_column :passenger_associations, :n_prenotati, :integer
  end
end
