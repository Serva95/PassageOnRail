require "application_system_test_case"

class DriversTest < ApplicationSystemTestCase
  setup do
    @driver = drivers(:one)
  end

  test "visiting the index" do
    visit drivers_url
    assert_selector "h1", text: "Drivers"
  end

  test "creating a Driver" do
    visit drivers_url
    click_on "New Driver"

    check "Deleted" if @driver.deleted
    fill_in "Rating medio", with: @driver.rating_medio
    click_on "Create Driver"

    assert_text "Driver was successfully created"
    click_on "Back"
  end

  test "updating a Driver" do
    visit drivers_url
    click_on "Edit", match: :first

    check "Deleted" if @driver.deleted
    fill_in "Rating medio", with: @driver.rating_medio
    click_on "Update Driver"

    assert_text "Driver was successfully updated"
    click_on "Back"
  end

  test "destroying a Driver" do
    visit drivers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Driver was successfully destroyed"
  end
end
