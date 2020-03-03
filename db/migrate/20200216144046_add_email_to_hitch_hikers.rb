class AddEmailToHitchHikers < ActiveRecord::Migration[6.0]
  def change
    add_column :hitch_hikers, :email, :string
  end
end
