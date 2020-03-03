require "application_system_test_case"

class PassengerAssociationsTest < ApplicationSystemTestCase
  setup do
    @passenger_association = passenger_associations(:one)
  end

  test "visiting the index" do
    visit passenger_associations_url
    assert_selector "h1", text: "Passenger Associations"
  end

  test "creating a Passenger association" do
    visit passenger_associations_url
    click_on "New Passenger Association"

    click_on "Create Passenger association"

    assert_text "Passenger association was successfully created"
    click_on "Back"
  end

  test "updating a Passenger association" do
    visit passenger_associations_url
    click_on "Edit", match: :first

    click_on "Update Passenger association"

    assert_text "Passenger association was successfully updated"
    click_on "Back"
  end

  test "destroying a Passenger association" do
    visit passenger_associations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Passenger association was successfully destroyed"
  end
end
