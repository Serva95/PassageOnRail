class ChangeReferenceRatingRewiew < ActiveRecord::Migration[6.0]
  def change
    remove_column :ratings, :hitch_hiker_id, :integer
    add_reference :ratings, :user, foreign_key: true
    remove_column :reviews, :hitch_hiker_id, :integer
    add_reference :reviews, :user, foreign_key: true

  end
end
