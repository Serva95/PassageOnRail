class RouteNPValidator < ActiveModel::Validator
  def validate(record)
    if record.n_passeggeri.blank?
      record.errors[:n_passeggeri] << "Non può essere nil"
      #non si possono aggiungere più passeggeri dei posti diponibili nella macchina
      elsif record.n_passeggeri > Vehicle.estrai_posti(record.vehicle_id)
        record.errors[:n_passeggeri] << "La macchina è piena"
    end
  end
end

class Route < ApplicationRecord
  validates :citta_partenza, presence: true
  validates :luogo_ritrovo, presence: true
  validates :data_ora_partenza, presence: true
  validates :citta_arrivo, presence: true
  validates :data_ora_arrivo, presence: true
  validates :costo, presence: true
  validates_with RouteNPValidator
  #validates :n_passeggeri, presence: true

	belongs_to :driver
	belongs_to :vehicle

  has_many :stages
  has_many :journeys, :through => :stages

  #estrae il numero di passeggeri attualmente prenotati
  scope :current_passengers, -> (route_id) do
    select('n_passeggeri').where('id = ?', route_id)
  end

  #somma i passeggeri prenotati con quelli che si vogliono prenotare
  def self.sum_passengers(route_id, n_prenotati)
    route = Route.current_passengers(route_id)
    route.first.n_passeggeri + n_prenotati
  end

  #estrai il massimo numero di posti che si possono aggiungere
  def self.posti_disponibili(route_id,vehicle_id)
    v = Vehicle.estrai_posti(vehicle_id)
    r = Route.current_passengers(route_id)
    v - r.first.n_passeggeri
  end

  def self.already_booked(route_id,hitch_hiker_id)
    stages = Stage.joins(:journey).where("route_id = ? AND journeys.user_id = ?", route_id,hitch_hiker_id)
  end

  def self.search(search)
    if search
      where(["citta_partenza LIKE ?" , "%#{search}%"])
    else
      all
    end
  end


end
