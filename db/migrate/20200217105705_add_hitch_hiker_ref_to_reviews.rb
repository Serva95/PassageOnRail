class AddHitchHikerRefToReviews < ActiveRecord::Migration[6.0]
  def change
    add_reference :reviews, :hitch_hiker, foreign_key: true
  end
end
