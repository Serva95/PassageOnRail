require 'test_helper'

describe "Chat notification json", :integration do
  test "chat_notification_json" do
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

    get "/chats.json", xhr: true

    assert_equal "[]", @response.body
    assert_equal "application/json", @response.media_type
  end
end
