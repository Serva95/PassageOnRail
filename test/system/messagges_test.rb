require "application_system_test_case"

class MessaggesTest < ApplicationSystemTestCase
  setup do
    @messagge = messagges(:one)
  end

  test "visiting the index" do
    visit messagges_url
    assert_selector "h1", text: "Messagges"
  end

  test "creating a Messagge" do
    visit messagges_url
    click_on "New Messagge"

    fill_in "Data ora", with: @messagge.data_ora
    fill_in "Destinatario", with: @messagge.destinatario
    fill_in "Mittente", with: @messagge.mittente
    fill_in "Testo", with: @messagge.testo
    click_on "Create Messagge"

    assert_text "Messagge was successfully created"
    click_on "Back"
  end

  test "updating a Messagge" do
    visit messagges_url
    click_on "Edit", match: :first

    fill_in "Data ora", with: @messagge.data_ora
    fill_in "Destinatario", with: @messagge.destinatario
    fill_in "Mittente", with: @messagge.mittente
    fill_in "Testo", with: @messagge.testo
    click_on "Update Messagge"

    assert_text "Messagge was successfully updated"
    click_on "Back"
  end

  test "destroying a Messagge" do
    visit messagges_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Messagge was successfully destroyed"
  end
end
