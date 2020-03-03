require "application_system_test_case"

class HitchHikersTest < ApplicationSystemTestCase
  setup do
    @hitch_hiker = hitch_hikers(:one)
  end

  test "visiting the index" do
    visit hitch_hikers_url
    assert_selector "h1", text: "Hitch Hikers"
  end

  test "creating a Hitch hiker" do
    visit hitch_hikers_url
    click_on "New Hitch Hiker"

    check "Deleted" if @hitch_hiker.deleted
    fill_in "Rating medio", with: @hitch_hiker.rating_medio
    click_on "Create Hitch hiker"

    assert_text "Hitch hiker was successfully created"
    click_on "Back"
  end

  test "updating a Hitch hiker" do
    visit hitch_hikers_url
    click_on "Edit", match: :first

    check "Deleted" if @hitch_hiker.deleted
    fill_in "Rating medio", with: @hitch_hiker.rating_medio
    click_on "Update Hitch hiker"

    assert_text "Hitch hiker was successfully updated"
    click_on "Back"
  end

  test "destroying a Hitch hiker" do
    visit hitch_hikers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Hitch hiker was successfully destroyed"
  end
end
