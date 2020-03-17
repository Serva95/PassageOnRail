class AddMultitripToSearches < ActiveRecord::Migration[6.0]
  def change
  add_column :searches, :multitrip, :boolean
  end
end
