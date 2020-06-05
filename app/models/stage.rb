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

  # @param [Journey] journey
  # @param [Route] route
  #
  # @author serva
  #
  # @note dato un oggetto journey e uno route da eliminare, controlla se ha uno o due stage,
  # @note se ne ha uno elimina il journey e decrementa il numero di passeggeri nella route
  # @note se ne ha due elimina il relativo stage e decrementa il numero di passeggeri nella route
  #
  # da cambiare
  def self.delete_stage(journey, route)
    stage = Stage.where("journey_id = ? and route_id = ?", journey.id, route.id).first
    ActiveRecord::Base.transaction do
      stage.destroy!
      route.decrement!(:n_passeggeri, by = journey.n_prenotati)
    end
  end

end
