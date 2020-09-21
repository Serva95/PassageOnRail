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
         params: {user: {email: "lorenzo@test.it", password: "password"}}
    assert_response :redirect
    follow_redirect!
    assert_equal 200, status
    assert_equal "/", path

    get "/searches/new"
    assert_equal 200, status

    post "/searches",
      params: {search: {c_partenza: "Ferrara", c_arrivo: "Bologna"}}
    assert_response :redirect
    follow_redirect!
    assert_equal 200, status
    assert_select "th", "Città di partenza"

    get "/routes/detail?ids%5B%5D=15"
    assert_equal 200, status
    assert_select "strong", "Dettagli percorso"

    get "/journeys/new?ids%5B%5D=15"
    assert_equal 200, status
    assert_select "strong", "Prenota il viaggio"

    post "/journeys",
      params: {journey: {user_id: 8, n_prenotati: 1, stages_attributes: {"0": {route_id: 15}}}}
    assert_response :redirect
    follow_redirect!
    assert_equal 200, status

  end

end
