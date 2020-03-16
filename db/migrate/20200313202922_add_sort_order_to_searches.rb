class AddSortOrderToSearches < ActiveRecord::Migration[6.0]
  def change
	add_column :searches, :sort_order, :string
  end
end
