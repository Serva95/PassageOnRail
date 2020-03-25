class ChatColumnNameChange < ActiveRecord::Migration[6.0]
  def change
    rename_column(:chats, :created_at, :opened_at)
  end
end
