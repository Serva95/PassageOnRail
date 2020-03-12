class AddComfortNToSearches < ActiveRecord::Migration[6.0]
  def change
	add_column :searches, :comfort, :integer
  end
end
