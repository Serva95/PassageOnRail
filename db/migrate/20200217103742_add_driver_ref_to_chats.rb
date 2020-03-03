class AddDriverRefToChats < ActiveRecord::Migration[6.0]
  def change
    add_reference :chats, :driver, foreign_key: true
  end
end
