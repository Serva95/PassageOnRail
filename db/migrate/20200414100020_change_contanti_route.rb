class ChangeContantiRoute < ActiveRecord::Migration[6.0]
  def change
    change_column :routes, :contanti, :boolean,{null: false, default: false}
  end
end
