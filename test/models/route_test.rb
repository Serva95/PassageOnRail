require 'test_helper'

class RouteTest < ActiveSupport::TestCase
  test "posti_disponibili should return number of places available on route" do
    r = routes(:ferrara_bologna_booked)
    assert_equal 3, r.posti_disponibili
  end

  # test "find_passengers che data una route restituisce i passeggeri prenotati" DA FARE

  test "find_journeys che data una route trova tutte le journey associate" do
    r1 = routes(:bologna_milano_booked)
    j = journeys(:one)
    r_unbooked = routes(:ferrara_bologna_unbooked)
    assert_includes r1.find_journeys(r1.id), j
    assert_empty r_unbooked.find_journeys(r_unbooked.id)
  end

end
