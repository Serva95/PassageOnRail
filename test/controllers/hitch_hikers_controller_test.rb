require 'test_helper'

class HitchHikersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hitch_hiker = hitch_hikers(:one)
  end

  test "should get index" do
    get hitch_hikers_url
    assert_response :success
  end

  test "should get new" do
    get new_hitch_hiker_url
    assert_response :success
  end

  test "should create hitch_hiker" do
    assert_difference('HitchHiker.count') do
      post hitch_hikers_url, params: { hitch_hiker: { deleted: @hitch_hiker.deleted, rating_medio: @hitch_hiker.rating_medio } }
    end

    assert_redirected_to hitch_hiker_url(HitchHiker.last)
  end

  test "should show hitch_hiker" do
    get hitch_hiker_url(@hitch_hiker)
    assert_response :success
  end

  test "should get edit" do
    get edit_hitch_hiker_url(@hitch_hiker)
    assert_response :success
  end

  test "should update hitch_hiker" do
    patch hitch_hiker_url(@hitch_hiker), params: { hitch_hiker: { deleted: @hitch_hiker.deleted, rating_medio: @hitch_hiker.rating_medio } }
    assert_redirected_to hitch_hiker_url(@hitch_hiker)
  end

  test "should destroy hitch_hiker" do
    assert_difference('HitchHiker.count', -1) do
      delete hitch_hiker_url(@hitch_hiker)
    end

    assert_redirected_to hitch_hikers_url
  end
end
