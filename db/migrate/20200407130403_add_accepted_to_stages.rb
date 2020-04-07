class AddAcceptedToStages < ActiveRecord::Migration[6.0]
  def change
    add_column :stages, :accepted, :boolean
  end
end
