require "application_system_test_case"

class RoutesTest < ApplicationSystemTestCase
  setup do
    @route = routes(:one)
  end

  test "visiting the index" do
    visit routes_url
    assert_selector "h1", text: "Routes"
  end

  test "creating a Route" do
    visit routes_url
    click_on "New Route"

    fill_in "Citta arrivo", with: @route.citta_arrivo
    fill_in "Citta partenza", with: @route.citta_partenza
    fill_in "Costo", with: @route.costo
    fill_in "Data ora arrivo", with: @route.data_ora_arrivo
    fill_in "Data ora partenza", with: @route.data_ora_partenza
    check "Deleted" if @route.deleted
    fill_in "Luogo ritrovo", with: @route.luogo_ritrovo
    click_on "Create Route"

    assert_text "Route was successfully created"
    click_on "Back"
  end

  test "updating a Route" do
    visit routes_url
    click_on "Edit", match: :first

    fill_in "Citta arrivo", with: @route.citta_arrivo
    fill_in "Citta partenza", with: @route.citta_partenza
    fill_in "Costo", with: @route.costo
    fill_in "Data ora arrivo", with: @route.data_ora_arrivo
    fill_in "Data ora partenza", with: @route.data_ora_partenza
    check "Deleted" if @route.deleted
    fill_in "Luogo ritrovo", with: @route.luogo_ritrovo
    click_on "Update Route"

    assert_text "Route was successfully updated"
    click_on "Back"
  end

  test "destroying a Route" do
    visit routes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Route was successfully destroyed"
  end
end
