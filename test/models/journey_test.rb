require 'test_helper'

class JourneyTest < ActiveSupport::TestCase
  test "#find_requests(driver_id) should return a list of journeys" do
    d = drivers(:with_route)
    j = journeys(:four)
    assert_includes Journey.find_requests(d.id), j
  end

  test "#find_request(driver_id) should not return journey of other drivers" do
    d = drivers(:with_route)
    j = journeys(:five)
    assert_not_includes Journey.find_requests(d.id), j
  end

  test "#find_requests(driver_id) should contain user's information" do
    d = drivers(:with_route)
    u = users(:four)
    assert_equal Journey.find_requests(d.id).first.user, u
  end


end