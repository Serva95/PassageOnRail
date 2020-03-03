json.extract! route, :id, :citta_partenza, :luogo_ritrovo, :data_ora_partenza, :citta_arrivo, :data_ora_arrivo, :costo, :deleted, :created_at, :updated_at
json.url route_url(route, format: :json)
