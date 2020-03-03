class CreateHitchHikers < ActiveRecord::Migration[6.0]
  def change
    create_table :hitch_hikers do |t|
      t.float :rating_medio
      t.boolean :deleted

      t.timestamps
    end
  end
end
