class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.datetime :data
      t.integer :rating
      t.text :commento
      t.boolean :deleted

      t.timestamps
    end
  end
end
