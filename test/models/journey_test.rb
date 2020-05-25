require 'test_helper'

class JourneyTest < ActiveSupport::TestCase
  test "#find_requests(driver_id) should return a list of journeys" do
    d = drivers(:with_route)
    j = journeys(:four)
    #r = routes(:bologna_milano_booked)
    #s1 = stages(:bologna_milano)
    #s2 = stages(:ferrara_bologna)
    assert_includes Journey.find_requests(d.id), j
  end

  test "#find_request(driver_id) should not return journey of other drivers" do
    d = drivers(:with_route)
    j = journeys(:five)
    assert_not_includes Journey.find_requests(d.id), j
  end
end