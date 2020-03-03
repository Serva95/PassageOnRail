require "application_system_test_case"

class MultiTripsTest < ApplicationSystemTestCase
  setup do
    @multi_trip = multi_trips(:one)
  end

  test "visiting the index" do
    visit multi_trips_url
    assert_selector "h1", text: "Multi Trips"
  end

  test "creating a Multi trip" do
    visit multi_trips_url
    click_on "New Multi Trip"

    fill_in "Citta arrivo", with: @multi_trip.citta_arrivo
    fill_in "Citta partenza", with: @multi_trip.citta_partenza
    fill_in "Comfort medio", with: @multi_trip.comfort_medio
    fill_in "Costo totale", with: @multi_trip.costo_totale
    fill_in "Data ora arrivo", with: @multi_trip.data_ora_arrivo
    fill_in "Data ora partenza", with: @multi_trip.data_ora_partenza
    fill_in "Numero cambi", with: @multi_trip.numero_cambi
    click_on "Create Multi trip"

    assert_text "Multi trip was successfully created"
    click_on "Back"
  end

  test "updating a Multi trip" do
    visit multi_trips_url
    click_on "Edit", match: :first

    fill_in "Citta arrivo", with: @multi_trip.citta_arrivo
    fill_in "Citta partenza", with: @multi_trip.citta_partenza
    fill_in "Comfort medio", with: @multi_trip.comfort_medio
    fill_in "Costo totale", with: @multi_trip.costo_totale
    fill_in "Data ora arrivo", with: @multi_trip.data_ora_arrivo
    fill_in "Data ora partenza", with: @multi_trip.data_ora_partenza
    fill_in "Numero cambi", with: @multi_trip.numero_cambi
    click_on "Update Multi trip"

    assert_text "Multi trip was successfully updated"
    click_on "Back"
  end

  test "destroying a Multi trip" do
    visit multi_trips_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Multi trip was successfully destroyed"
  end
end
