require 'test_helper'

class PassengerAssociationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @passenger_association = passenger_associations(:one)
  end

  test "should get index" do
    get passenger_associations_url
    assert_response :success
  end

  test "should get new" do
    get new_passenger_association_url
    assert_response :success
  end

  test "should create passenger_association" do
    assert_difference('PassengerAssociation.count') do
      post passenger_associations_url, params: { passenger_association: {  } }
    end

    assert_redirected_to passenger_association_url(PassengerAssociation.last)
  end

  test "should show passenger_association" do
    get passenger_association_url(@passenger_association)
    assert_response :success
  end

  test "should get edit" do
    get edit_passenger_association_url(@passenger_association)
    assert_response :success
  end

  test "should update passenger_association" do
    patch passenger_association_url(@passenger_association), params: { passenger_association: {  } }
    assert_redirected_to passenger_association_url(@passenger_association)
  end

  test "should destroy passenger_association" do
    assert_difference('PassengerAssociation.count', -1) do
      delete passenger_association_url(@passenger_association)
    end

    assert_redirected_to passenger_associations_url
  end
end
