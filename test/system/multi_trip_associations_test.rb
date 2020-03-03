require "application_system_test_case"

class MultiTripAssociationsTest < ApplicationSystemTestCase
  setup do
    @multi_trip_association = multi_trip_associations(:one)
  end

  test "visiting the index" do
    visit multi_trip_associations_url
    assert_selector "h1", text: "Multi Trip Associations"
  end

  test "creating a Multi trip association" do
    visit multi_trip_associations_url
    click_on "New Multi Trip Association"

    click_on "Create Multi trip association"

    assert_text "Multi trip association was successfully created"
    click_on "Back"
  end

  test "updating a Multi trip association" do
    visit multi_trip_associations_url
    click_on "Edit", match: :first

    click_on "Update Multi trip association"

    assert_text "Multi trip association was successfully updated"
    click_on "Back"
  end

  test "destroying a Multi trip association" do
    visit multi_trip_associations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Multi trip association was successfully destroyed"
  end
end
