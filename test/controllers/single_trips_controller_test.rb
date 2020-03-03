require 'test_helper'

class SingleTripsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @single_trip = single_trips(:one)
  end

  test "should get index" do
    get single_trips_url
    assert_response :success
  end

  test "should get new" do
    get new_single_trip_url
    assert_response :success
  end

  test "should create single_trip" do
    assert_difference('SingleTrip.count') do
      post single_trips_url, params: { single_trip: { n_passeggeri: @single_trip.n_passeggeri } }
    end

    assert_redirected_to single_trip_url(SingleTrip.last)
  end

  test "should show single_trip" do
    get single_trip_url(@single_trip)
    assert_response :success
  end

  test "should get edit" do
    get edit_single_trip_url(@single_trip)
    assert_response :success
  end

  test "should update single_trip" do
    patch single_trip_url(@single_trip), params: { single_trip: { n_passeggeri: @single_trip.n_passeggeri } }
    assert_redirected_to single_trip_url(@single_trip)
  end

  test "should destroy single_trip" do
    assert_difference('SingleTrip.count', -1) do
      delete single_trip_url(@single_trip)
    end

    assert_redirected_to single_trips_url
  end
end
