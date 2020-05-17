require 'test_helper'

class VehicleTest < ActiveSupport::TestCase

  test "#max_passeggeri should return vehicle.posti" do
    v = vehicles(:has_4_seats)
    assert_equal v.max_passeggeri(1), 4
  end

end
