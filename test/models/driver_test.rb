require 'test_helper'

class DriverTest < ActiveSupport::TestCase
  test "#has_routes(id) should return if driver has route" do
    d1 = drivers(:with_route)
    d2 = drivers(:no_route)
    assert d1.has_routes(d1.id)
    assert_not d2.has_routes(d2.id)
  end

  test "#self.delete_driver should delete driver" do
    d = drivers(:no_route)
    u = users(:delete_driver)
    Driver.delete_driver(u, d)
    assert_equal u.driver_id, nil
  end
end
