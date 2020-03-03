class AddHitchHikerRefToChats < ActiveRecord::Migration[6.0]
  def change
    add_reference :chats, :hitch_hiker, foreign_key: true
  end
end
