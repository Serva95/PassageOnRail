require 'test_helper'

class MultiTripsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @multi_trip = multi_trips(:one)
  end

  test "should get index" do
    get multi_trips_url
    assert_response :success
  end

  test "should get new" do
    get new_multi_trip_url
    assert_response :success
  end

  test "should create multi_trip" do
    assert_difference('MultiTrip.count') do
      post multi_trips_url, params: { multi_trip: { citta_arrivo: @multi_trip.citta_arrivo, citta_partenza: @multi_trip.citta_partenza, comfort_medio: @multi_trip.comfort_medio, costo_totale: @multi_trip.costo_totale, data_ora_arrivo: @multi_trip.data_ora_arrivo, data_ora_partenza: @multi_trip.data_ora_partenza, numero_cambi: @multi_trip.numero_cambi } }
    end

    assert_redirected_to multi_trip_url(MultiTrip.last)
  end

  test "should show multi_trip" do
    get multi_trip_url(@multi_trip)
    assert_response :success
  end

  test "should get edit" do
    get edit_multi_trip_url(@multi_trip)
    assert_response :success
  end

  test "should update multi_trip" do
    patch multi_trip_url(@multi_trip), params: { multi_trip: { citta_arrivo: @multi_trip.citta_arrivo, citta_partenza: @multi_trip.citta_partenza, comfort_medio: @multi_trip.comfort_medio, costo_totale: @multi_trip.costo_totale, data_ora_arrivo: @multi_trip.data_ora_arrivo, data_ora_partenza: @multi_trip.data_ora_partenza, numero_cambi: @multi_trip.numero_cambi } }
    assert_redirected_to multi_trip_url(@multi_trip)
  end

  test "should destroy multi_trip" do
    assert_difference('MultiTrip.count', -1) do
      delete multi_trip_url(@multi_trip)
    end

    assert_redirected_to multi_trips_url
  end
end
