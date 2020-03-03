require "application_system_test_case"

class SingleTripsTest < ApplicationSystemTestCase
  setup do
    @single_trip = single_trips(:one)
  end

  test "visiting the index" do
    visit single_trips_url
    assert_selector "h1", text: "Single Trips"
  end

  test "creating a Single trip" do
    visit single_trips_url
    click_on "New Single Trip"

    fill_in "N passeggeri", with: @single_trip.n_passeggeri
    click_on "Create Single trip"

    assert_text "Single trip was successfully created"
    click_on "Back"
  end

  test "updating a Single trip" do
    visit single_trips_url
    click_on "Edit", match: :first

    fill_in "N passeggeri", with: @single_trip.n_passeggeri
    click_on "Update Single trip"

    assert_text "Single trip was successfully updated"
    click_on "Back"
  end

  test "destroying a Single trip" do
    visit single_trips_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Single trip was successfully destroyed"
  end
end
