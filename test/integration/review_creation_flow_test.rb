require 'test_helper'

describe "Review creation flow", :integration do
  test "review_creation_flow" do
    get "/"
    assert_equal 200, status
    assert_equal "/", path
    assert_select "h3", "Cerchi un viaggio?"
    get "/users/sign_in"
    assert_equal 200, status
    assert_select "h2", "Log in"

    post "/users/sign_in",
         params: {user: {email: "lorenzo@test.it", password: "password", }}
    assert_response :redirect
    follow_redirect!
    assert_equal 200, status
    assert_equal "/", path

    get "/users/8/bookings"
    assert_equal 200, status

    get "/users/8/bookings/detail?j_id=7"
    assert_equal 200, status

    get "/users/1"
    assert_equal 200, status

    get "/reviews?user_id=1"
    assert_equal 200, status

    get "/reviews/new?user_id=1"
    assert_equal 200, status

    post "/reviews",
         params: {review: {data: Date.today, vote: "5", commento: "Guida bene", user_id: "1"}}
    assert_response :redirect
    follow_redirect!
    assert_equal 200, status
    assert_select "h2", "Recensioni guidatore"
  end
end
