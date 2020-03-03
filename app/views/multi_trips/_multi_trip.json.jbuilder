json.extract! multi_trip, :id, :data_ora_partenza, :citta_partenza, :data_ora_arrivo, :citta_arrivo, :costo_totale, :comfort_medio, :numero_cambi, :created_at, :updated_at
json.url multi_trip_url(multi_trip, format: :json)
