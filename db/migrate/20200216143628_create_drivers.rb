class CreateDrivers < ActiveRecord::Migration[6.0]
  def change
    create_table :drivers do |t|
      t.float :rating_medio
      t.boolean :deleted

      t.timestamps
    end
  end
end
