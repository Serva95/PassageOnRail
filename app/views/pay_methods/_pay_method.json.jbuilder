json.extract! pay_method, :id, :numero, :intestatario, :mese_scadenza, :anno_scadenza, :cvv, :user_id, :created_at, :updated_at
json.url user_pay_method_url(user, format: :json)
