class AddDriverRefToReviews < ActiveRecord::Migration[6.0]
  def change
    add_reference :reviews, :driver, foreign_key: true
  end
end
