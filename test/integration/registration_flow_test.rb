require 'test_helper'

describe "Registration flow", :integration do
  test "sign_up" do
    get "/"
    assert_equal 200, status
    assert_equal "/", path
    assert_select "h3", "Cerchi un viaggio?"
    get "/users/sign_in"
    assert_equal 200, status
    assert_select "h2", "Log in"

    get "/users/sign_up"
    assert_select "h2", "Sign up"

    post "/users/",
         params: {user: {email: "email@test.it", password: "pwdtest", password_confirmaton: "pwdtest", username: "test",
                         nome: "nome", cognome: "cognome", data_di_nascita: "1996-08-21",  }}
    # Verifico che la mail di conferma venga effettivamente inviata
    assert_emails 1
    assert_response :redirect
    follow_redirect!
    assert_equal 200, status
    assert_equal "/", path
  end

  # La conferma dell'email è una funzionalità implementata da devise e quindi già testata

  test "log in, become a driver and add a vehicle" do
    # utilizzo user sign_up_flow per verificare il resto del flusso
    user = users(:sign_up_flow)
    sign_in user
    post "/users/sign_in"
    assert_response :redirect
    follow_redirect!
    assert_equal "/", path
    assert_select "div", "Diventa Driver!"

    get "/drivers/new"
    assert_select "h3", "Hai dei posti liberi per il tuo viaggio e vuoi dividere le spese?"

    post "/drivers"
    assert_response :redirect
    follow_redirect!
    assert_equal "/drivers/101/vehicles/new", path

    post "/drivers/101/vehicles",
         params: {vehicle:{ targa: "AB123CD", marca: "Fiat", modello: "panda", tipo_mezzo: "autocarro", comfort: "5",
                            posti: "2"}}
    assert_response :redirect
    follow_redirect!
    assert_equal "/drivers/101/vehicles", path
  end
end
