class ChatDeletedForUsers < ActiveRecord::Migration[6.0]
  def change
    add_column(:chats, :deleted_user_1, :boolean, null: false, :default => false)
    add_column(:chats, :deleted_user_2, :boolean, null: false, :default => false)
  end
end
