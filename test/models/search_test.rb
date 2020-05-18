require 'test_helper'

class SearchTest < ActiveSupport::TestCase

  test "#already_booked(user_1) should find the id of user's already booked routes " do
    r1 = routes(:ferrara_bologna_booked)
    r2 = routes(:bologna_milano_booked)
    u = users(:one)
    s = searches(:ferrara_bologna)
    assert_includes s.already_booked(u.id), r1.id
    assert_includes s.already_booked(u.id), r2.id
  end

  test "#search_routes(driver_1,booked_routes) should return single routes that meet the search parameters" do
    r = routes(:ferrara_bologna_unbooked)
    booked = routes(:ferrara_bologna_booked).id
    u = users(:one)
    s = searches(:ferrara_bologna)
    assert_includes s.search_routes(u.driver_id,booked),r
  end

  # test "#multi_routes_search(driver_1,booked_routes) should return couple of routes that meet the search parameters" do
  #   r1 = routes(:ferrara_bologna_unbooked)
  #   r2 = routes(:bologna_venezia_unbooked)
  #   booked = routes(:ferrara_bologna_booked).id
  #   u = users(:one)
  #   s = searches(:ferrara_venezia)
  #   assert_equal s.multi_routes_search(u.driver_id,booked).c_part, r1.citta_partenza
  #   assert_equal s.multi_routes_search(u.driver_id,booked).c_arr, r2.citta_arrivo
  # end

end
