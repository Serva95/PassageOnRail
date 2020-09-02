require 'test_helper'

describe "Registration flow", :integration do
  test "sign_up" do
    get "/"
    assert_response :redirect
    follow_redirect!
    assert_select "h2", "Log in"

    get "/users/sign_up"
    assert_select "h2", "Sign up"

    post "/users/",
         params: {user: {email: "email@test.it", password: "pwdtest", password_confirmaton: "pwdtest", username: "test",
                         nome: "nome", cognome: "cognome", data_di_nascita: "1996-08-21",  }}
    assert_response :redirect
    follow_redirect!
    assert_equal 302, status
    follow_redirect!
    assert_equal "/users/sign_in", path

    # utilizzo user sign_up_flow per verificare il resto del flusso
    # user = users(:sign_up_flow)
    # post "/users/sign_in",
    #      params:{ user: {email: user.email, password: "pwdtest"}}
    # assert_response :success
    # follow_redirect!
    # assert_select "div", "Email o password non validi."


  end
end
