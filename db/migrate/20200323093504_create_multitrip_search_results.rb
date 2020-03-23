class CreateMultitripSearchResults < ActiveRecord::Migration[6.0]
  def change
    create_view :multitrip_search_results
  end
end
