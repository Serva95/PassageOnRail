class AddChatRefToMessagges < ActiveRecord::Migration[6.0]
  def change
    add_reference :messagges, :chat, foreign_key: true
  end
end
