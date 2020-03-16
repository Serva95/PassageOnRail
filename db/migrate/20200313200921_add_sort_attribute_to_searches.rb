class AddSortAttributeToSearches < ActiveRecord::Migration[6.0]
  def change
	add_column :searches, :sort_attribute, :string
  end
end
