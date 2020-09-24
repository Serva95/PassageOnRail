class Stage < ApplicationRecord
  belongs_to :route
  belongs_to :journey

  # controlla se lo stage è già stato controllato (accettato o rifiutato) dal driver
  scope :already_checked, -> (route_id,journey_id) do
    where("route_id = ? AND journey_id = ?",route_id,journey_id).first
  end

  # dato un oggetto journey e uno route da eliminare, controlla se ha uno o due stage,
  # se ne ha uno elimina il journey e decrementa il numero di passeggeri nella route
  # ne ha due elimina il relativo stage e decrementa il numero di passeggeri nella route
  #
  # da cambiare
  def self.delete_stage(journey, route)
    stage = Stage.where("journey_id = ? and route_id = ?", journey.id, route.id).first
    ActiveRecord::Base.transaction do
      stage.destroy!
      route.decrement!(:n_passeggeri, by = journey.n_prenotati)
    end
  end

  # transaction che decrementa il numero di passeggeri e
  # setta a false la stage rifiutata
  def reject(n_passeggeri)
    self.transaction do
      self.route.decrement!(:n_passeggeri, n_passeggeri)
      self.update!(accepted: false)
    end
  end

end
