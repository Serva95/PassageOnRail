json.extract! user, :id, :email, :username, :password, :nome, :cognome, :data_di_nascita, :cellulare, :indirizzo, :url_foto, :deleted, :created_at, :updated_at
json.url user_url(user, format: :json)
