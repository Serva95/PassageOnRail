class Users < ActiveRecord::Migration[6.0]
  def change
    rename_column(:users, :drivers_id, "driver_id")
    rename_column(:users, :hitch_hikers_id, "hitch_hiker_id")
  end
end
