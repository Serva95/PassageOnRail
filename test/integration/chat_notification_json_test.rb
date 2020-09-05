require 'test_helper'

describe "Chat notification json", :integration do
  test "chat_notification_json" do
    get "/"
    assert_response :redirect
    follow_redirect!
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
