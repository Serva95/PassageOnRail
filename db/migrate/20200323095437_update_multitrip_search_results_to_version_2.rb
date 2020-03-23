class UpdateMultitripSearchResultsToVersion2 < ActiveRecord::Migration[6.0]
  def change
    update_view :multitrip_search_results, version: 2, revert_to_version: 1
  end
end
