require 'test_helper'

class RatingTest < ActiveSupport::TestCase

  # @note crea il rating a database, calcola la media con il nuovo inserito e aggiorna il dato nella row dello user
  test "self.new_rating_transaction(rating) should insert new rating in DB" do
    r = ratings(:insert)
    assert Rating.new_rating_transaction(r)
    #non capisco cosa non gli vada
  end

  # @note trova tutti i rating associati all'utente con id passato
  test "self.find_ratings(user_id) should find all rating of user with passed id" do
    rt1 = ratings(:one)
    rt2 = ratings(:two)
    rt3 = ratings(:insert)
    r = Rating.find_ratings(2)
    assert_includes r, rt1
    assert_includes r, rt2
    assert_not_includes r, rt3
  end

  # @note controlla se esiste già un rating da parte di quel driver a quello user (evita doppie valutazioni)
  test "self.exists(user_id, driver_id)" do
    assert Rating.exists(2,2)
  end

end
