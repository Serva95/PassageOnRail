require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  test "#new_review_transaction(review) should insert in database " do
    r = reviews(:to_be_inserted)
      assert Review.new_review_transaction(r)
  end

  # @note esiste già una recensione a DB da parte di quell'utente per quel diver ?
  test "self.exists(current_user_id, user_driver_id) should return true if exists" do
    r = Review.exists(2,2)
    assert_equal r, true
  end

  # @note trova l'utente in join con il dirver che abbia quell'id passato
  test "self.find_user(user_id) should return join user with driver having passed id" do
    u = Review.find_user(1)
    user = users(:one)
    assert_equal u, user
  end

  # @note trova tutte le review associate al driver con id passato
  test "self.find_reviews(driver_id) should return all reviews for driver with passed id" do
    rw1 = reviews(:one)
    rw2 = reviews(:two)
    rw3 = reviews(:to_be_inserted)
    r = Review.find_reviews(2)
    assert_includes r, rw1
    assert_includes r, rw2
    assert_not_includes r, rw3
  end
end