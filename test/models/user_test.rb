require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "#find_rating_driver should return the average rating of a driver" do
    u = users(:two)
    assert_equal 2, u.find_rating_driver
  end

  test "#find_rating_autostoppista should return the average rating of an hitch-hicker" do
    u = users(:two)
    assert_equal 2, u.find_rating_autostoppista
  end

  test "#find_bookings(user_id) should return user's journeys" do
    u = users(:one)
    j = journeys(:one)
    j2 = journeys(:two)
    assert_includes u.find_bookings(u.id), j
    assert_not_includes u.find_bookings(u.id), j2
  end

  test "#has_previous_journey_done(user_id, driver_id) should return true if user has already traveled with that driver " do
    u = users(:one)
    d = users(:two)
    assert User.has_previous_journey_done(u.id,d.driver_id)
  end

end
