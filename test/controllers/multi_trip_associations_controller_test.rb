require 'test_helper'

class MultiTripAssociationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @multi_trip_association = multi_trip_associations(:one)
  end

  test "should get index" do
    get multi_trip_associations_url
    assert_response :success
  end

  test "should get new" do
    get new_multi_trip_association_url
    assert_response :success
  end

  test "should create multi_trip_association" do
    assert_difference('MultiTripAssociation.count') do
      post multi_trip_associations_url, params: { multi_trip_association: {  } }
    end

    assert_redirected_to multi_trip_association_url(MultiTripAssociation.last)
  end

  test "should show multi_trip_association" do
    get multi_trip_association_url(@multi_trip_association)
    assert_response :success
  end

  test "should get edit" do
    get edit_multi_trip_association_url(@multi_trip_association)
    assert_response :success
  end

  test "should update multi_trip_association" do
    patch multi_trip_association_url(@multi_trip_association), params: { multi_trip_association: {  } }
    assert_redirected_to multi_trip_association_url(@multi_trip_association)
  end

  test "should destroy multi_trip_association" do
    assert_difference('MultiTripAssociation.count', -1) do
      delete multi_trip_association_url(@multi_trip_association)
    end

    assert_redirected_to multi_trip_associations_url
  end
end
