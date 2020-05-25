class Stage < ApplicationRecord
  belongs_to :route
  belongs_to :journey

  # controlla se lo stage è già stato controllato (accettato o rifiutato) dal driver
  scope :already_checked, -> (route_id,journey_id) do
    where("route_id = ? AND journey_id = ?",route_id,journey_id).first.accepted
  end

  # estrae il numero massimo di passeggeri che possono salire su un dato veicolo
  scope :max_passengers, -> (vehicle_id)  do
    select('posti').where('id = ?', vehicle_id).first.posti
  end

end
