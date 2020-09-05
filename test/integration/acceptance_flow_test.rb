require 'test_helper'

describe "Acceptance flow", :integration do
  test "driver accept user" do
    user = users(:one)
    sign_in user
    get "/drivers/1/journeys"
    assert_response :success

    assert_select "td", "MyString vorrebbe percorrere la tua stessa Tratta!"

    get "/routes/13/journeys/5/edit"
    assert_response :success
    patch "/routes/13/journeys/5?accept=true"
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end
end
