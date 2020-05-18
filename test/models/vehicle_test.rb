require 'test_helper'

class VehicleTest < ActiveSupport::TestCase

  test "#max_passeggeri should return vehicle.posti" do
    v = vehicles(:has_4_seats)
    assert_equal Vehicle.max_passengers(v.id), 4
  end

end
