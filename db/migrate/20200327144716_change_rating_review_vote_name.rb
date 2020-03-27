class ChangeRatingReviewVoteName < ActiveRecord::Migration[6.0]
  def change
    rename_column(:ratings, :rating, :vote)
    remove_columns(:ratings, :updated_at, :created_at)
    change_column_null(:ratings, :data, false)
    change_column_null(:ratings, :vote, false)

    rename_column(:reviews, :rating, :vote)
    remove_columns(:reviews, :updated_at, :created_at)
    change_column_null(:reviews, :data, false)
    change_column_null(:reviews, :vote, false)
  end
end
