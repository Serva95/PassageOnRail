require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "#find_rating_driver should return the average rating of a driver" do
    u = users(:two)
    assert_equal u.find_rating_driver, 2
  end

  test "#find_rating_autostoppista should return the average rating of an hitch-hicker" do
    u = users(:two)
    assert_equal u.find_rating_autostoppista, 2
  end

  test "#find_bookings(user_id) should return user's journeys" do
    u = users(:one)
    j = journeys(:one)
    assert_includes u.find_bookings(u.id), j
    assert_not_empty u.find_bookings(u.id)
  end

  test "#has_previous_journey_done(user_id, driver_id) should return true if user has already traveled with that driver " do
    u = users(:one)
    d = users(:two)
    j = journeys(:old_journey)
    assert_includes u.has_previous_journey_done(u.id,d.driver_id), j
    assert_not_empty u.has_previous_journey_done(u.id,d.driver_id)
  end

end
