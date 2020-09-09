require 'test_helper'

describe "Search booking flow", :integration do

  test "log_in_and_search_flow" do

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

    get "/searches/new"
    assert_equal 200, status

    post "/searches",
      params: {search: {c_partenza: "ferrara", c_arrivo: "bologna"}}
    assert_response :redirect
    follow_redirect!
    assert_equal 200, status
    assert_select "th", "Città di partenza"

  end

end
