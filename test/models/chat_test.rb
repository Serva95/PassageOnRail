require 'test_helper'

class ChatTest < ActiveSupport::TestCase

  test "#find_chats(user_1) should return all chats of user_1" do
    c1 = chats(:one)
    c2 = chats(:two)
    assert_includes Chat.find_chats(1), c1
    assert_includes Chat.find_chats(1), c2
  end

  test "#exists(user_1,user_2) should return the chat if exists" do
    c = chats(:one)
    assert_equal Chat.exists(1,2), c
  end

  test "#delete_reset_side(chat, 1, true) should delete the chat for first user" do
    c = chats(:to_be_deleted)
    Chat.delete_reset_side(c,1,true)
    assert_equal true, c.deleted_user_1
  end

  test "#delete_reset_side(chat, 2, false) should reset the chat for the second user" do
    c = chats(:to_be_restored)
    Chat.delete_reset_side(c,2,false)
    assert_equal false, c.deleted_user_2
  end

end
