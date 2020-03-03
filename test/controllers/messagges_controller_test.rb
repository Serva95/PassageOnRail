require 'test_helper'

class MessaggesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @messagge = messagges(:one)
  end

  test "should get index" do
    get messagges_url
    assert_response :success
  end

  test "should get new" do
    get new_messagge_url
    assert_response :success
  end

  test "should create messagge" do
    assert_difference('Messagge.count') do
      post messagges_url, params: { messagge: { data_ora: @messagge.data_ora, destinatario: @messagge.destinatario, mittente: @messagge.mittente, testo: @messagge.testo } }
    end

    assert_redirected_to messagge_url(Messagge.last)
  end

  test "should show messagge" do
    get messagge_url(@messagge)
    assert_response :success
  end

  test "should get edit" do
    get edit_messagge_url(@messagge)
    assert_response :success
  end

  test "should update messagge" do
    patch messagge_url(@messagge), params: { messagge: { data_ora: @messagge.data_ora, destinatario: @messagge.destinatario, mittente: @messagge.mittente, testo: @messagge.testo } }
    assert_redirected_to messagge_url(@messagge)
  end

  test "should destroy messagge" do
    assert_difference('Messagge.count', -1) do
      delete messagge_url(@messagge)
    end

    assert_redirected_to messagges_url
  end
end
