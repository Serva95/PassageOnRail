require 'test_helper'

class MessaggeTest < ActiveSupport::TestCase

  # @note aggiorna l'orario di apertura della chat da parte dell'utente che l'ha aperta (per notifiche)
  test "self.update_open_time(update_time, chat_id, user_id) should have now for current user" do
    h = DateTime.current
    m = Messagge.update_open_time(h,1,1)
    assert_equal m.open_time_user_1.strftime("%d-%m-%Y %H:%M:%S"), h.strftime("%d-%m-%Y %H:%M:%S")
  end

  # @note controlla quale lato della chat appartiene all'utente che ha inviato il messaggio,
  # @note salva il nuovo messaggio inviato,
  # @note aggiorna l'orario di ultima modifica e l'orario di apertura dell'utente che ha mandato il msg
  test "self.new_msg_transaction(msg, update_time, chat, user_id)" do
    m = messagges(:tre)
    h = DateTime.current
    c = chats(:one)
    assert Messagge.new_msg_transaction(m, h, c, 1)
  end

  # @note cerca se esiste la chat con id chat_id, se esiste ->
  # @note cerca la chat relativa e controlla se l'utente che ha chiesto la chat ne è parte, se ne è parte ->
  # @note cerca tutti i messaggi appartenenti alla chat e li mostra
  # @note se limit è nil mostra solo i primi 15 messaggi, altrimenti tutti
  test "self.find_messages(chat_id, user_id, limit)" do
    m1 = messagges(:one)
    m2 = messagges(:two)
    m3 = messagges(:tre)
    m4 = messagges(:different_chat)
    m = Messagge.find_messages(1, 1, nil)
    assert_includes m, m1
    assert_includes m, m2
    assert_includes m, m3
    assert_not_includes m, m4
  end

  test "self.find_messages(chat_id, user_id, limit) should return forbidden" do
    m = Messagge.find_messages(3, 1, nil)
    assert_equal "forbidden" , m
  end

  test "self.find_messages(chat_id, user_id, limit) should return nothing" do
    m = Messagge.find_messages(333, 1, nil)
    assert_equal "nothing" , m
  end

  # @note cerca i nomi e i cognomi dei partecipanti alla chat per la pagina dei messaggi
  test "self.find_chatters(chat_id, current_user_id)" do
    m = Messagge.find_chatters(5, 3)
    assert_includes m, "gino"
    assert_includes m, "pino"
    assert_equal m.length, 2
  end

end
