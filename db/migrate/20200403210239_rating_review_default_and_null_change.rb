class RatingReviewDefaultAndNullChange < ActiveRecord::Migration[6.0]
  def change
    #correzione errore in precedente migration
    change_column_default(:messagges, :data_ora, 'CURRENT_TIMESTAMP')
    change_column_default(:chats, :open_time_user_1, 'CURRENT_TIMESTAMP')
    change_column_default(:chats, :open_time_user_2, 'CURRENT_TIMESTAMP')
    change_column_default(:chats, :updated_at, 'CURRENT_TIMESTAMP')

    #attuale migration
    change_column(:ratings, :data, :datetime, {default: 'CURRENT_TIMESTAMP', precision: 6})
    change_column(:reviews, :data, :datetime, {default: 'CURRENT_TIMESTAMP', precision: 6})
    change_column(:reviews, :deleted, :boolean, {default: false, null: false})
    change_column(:reviews, :commento, :text, {null: false})
  end
end
