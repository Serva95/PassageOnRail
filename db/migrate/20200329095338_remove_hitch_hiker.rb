class RemoveHitchHiker < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :hitch_hiker_id, :integer
    add_column :users, :hitch_hiker_rating, :float
    drop_table :hitch_hikers, {:force => :cascade}
  end
end
