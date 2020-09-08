require 'test_helper'

describe "Chat creation flow", :integration do
  test "chat_creation_flow" do
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

    get "/users/8/bookings/detail?j_id=6"
    assert_equal 200, status

    post "/chats",
         params: {chat: {user_2_id: "1"}}
    assert_response :redirect
    follow_redirect!
    assert_equal 200, status
    assert_select "h3", "Chat con Nome Cognome"
  end
end
