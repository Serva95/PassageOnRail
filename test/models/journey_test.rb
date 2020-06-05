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

  test "#booking should insert a new journey and one stage" do
    j = Journey.new(n_prenotati: 1, user_id: 1)
    j.stages.build(route_id: 12)
    assert j.booking
    r = routes(:verona_milano)
    assert_equal 2, r.n_passeggeri
  end

  test "#booking should not insert reservations for a user in a root already booked" do
    j = Journey.new(n_prenotati: 2, user_id: 4)
    j.stages.build(route_id: 12)
    assert_raises("Tratta già prenotata") {j.booking}
  end

  test "#journey_is_deletable(route) should return true if mancano 2 giorni" do
    r = routes(:verona_milano)
    assert_equal true, Journey.journey_is_deletable(r)
  end

  test "#delete_journey(journey, route) should delete a journey" do
    r = routes(:verona_milano,:milano_venezia)
    j = journeys(:five)
    assert Journey.delete_journey(j,r)
    assert_equal 0, r.first.n_passeggeri
  end


end