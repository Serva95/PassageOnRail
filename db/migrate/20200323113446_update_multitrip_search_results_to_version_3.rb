class UpdateMultitripSearchResultsToVersion3 < ActiveRecord::Migration[6.0]
  def change
    replace_view :multitrip_search_results, version: 3, revert_to_version: 2
  end
end
