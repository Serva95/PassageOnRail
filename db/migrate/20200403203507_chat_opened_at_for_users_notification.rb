class ChatOpenedAtForUsersNotification < ActiveRecord::Migration[6.0]
  def change
    rename_column(:chats, :opened_at, :open_time_user_1)
    change_column_default(:chats, :open_time_user_1, DateTime.now)
    add_column(:chats, :open_time_user_2, :timestamp, null: false, precision: 6, default: DateTime.now)
    change_column_default(:chats, :updated_at, DateTime.now)
    change_column(:messagges, :data_ora, :datetime, {precision: 6, default: DateTime.now})
  end
end
