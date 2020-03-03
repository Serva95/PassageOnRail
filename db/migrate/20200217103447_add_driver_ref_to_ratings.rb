class AddDriverRefToRatings < ActiveRecord::Migration[6.0]
  def change
    add_reference :ratings, :driver, foreign_key: true
  end
end
