class AddContatniToRoute < ActiveRecord::Migration[6.0]
  def change
    add_column :routes, :contanti, :boolean, null: false, default: true
  end
end
