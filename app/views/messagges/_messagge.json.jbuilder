json.extract! messagge, :id, :data_ora, :testo, :mittente, :destinatario, :created_at, :updated_at
json.url messagge_url(messagge, format: :json)
