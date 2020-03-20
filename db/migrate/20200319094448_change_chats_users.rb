class ChangeChatsUsers < ActiveRecord::Migration[6.0]
  def change
    drop_table :messagges
    drop_table :chats

    create_table :chats do |t|
      t.integer :user_1_id
      t.integer :user_2_id

      t.timestamps
    end

    create_table :messagges do |t|
      t.datetime :data_ora
      t.text :testo

      t.timestamps
    end

    add_reference :messagges, :chat, foreign_key: true
    add_reference :messagges, :user, foreign_key: true

    add_index :chats, :user_1_id, name: "index_chats_on_user_1_id", using: :btree
    add_index :chats, :user_2_id, name: "index_chats_on_user_2_id", using: :btree
    add_foreign_key :chats, :users, column: :user_1_id, primary_key: "id"
    add_foreign_key :chats, :users, column: :user_2_id, primary_key: "id"

  end
end
