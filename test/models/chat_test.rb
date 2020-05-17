require 'test_helper'

class ChatTest < ActiveSupport::TestCase

  test "#find_chats(user_1) should return all chats of user_1" do
    c1 = chats(:one)
    c2 = chats(:two)
    assert_includes Chat.find_chats(1), c1
    assert_includes Chat.find_chats(1), c2
  end

  test "#exists(user_1,user_2) should return the chat if exists" do
    c = chats(:two)
    assert_includes Chat.exists(1,2), c
  end

  test "#delete_reset_side(chat, 1, true) should delete the chat for the user_1" do
    c = chats(:to_be_deleted)
    c.delete_reset_side(c,1,true)
    assert_equal "true", Chats.find(chats(:to_be_deleted)).deleted_user_1
  end

  test "#delete_reset_side(chat, 2, false) should reset the chat for the user_2" do
    c = chats(:to_be_restored)
    c.delete_reset_side(c,2,false)
    assert_equal "false", Chats.find(chats(:to_be_deleted)).deleted_user_2
  end

end
