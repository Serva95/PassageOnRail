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

  has_many :stages, dependent: :destroy
  has_many :journeys, :through => :stages

  #estrae il numero di passeggeri attualmente prenotati
  scope :current_passengers, -> (route_id) do
    select('n_passeggeri').where('id = ?', route_id)
  end

  #estrai il massimo numero di posti che si possono aggiungere
  def self.posti_disponibili(route_id,vehicle_id)
    v = Vehicle.estrai_posti(vehicle_id)
    r = Route.current_passengers(route_id)
    v - r.first.n_passeggeri
  end

  def self.find_journeys(route_id)
    journeys = Journey.joins(:stages).where("route_id = ?", route_id)
  end

  def self.already_booked(route_id,hitch_hiker_id)
    stages = Stage.joins(:journey).where("route_id = ? AND journeys.user_id = ? AND accepted IS TRUE", route_id,hitch_hiker_id)
    if !stages.empty? #ci sono tratte prenotate da quell'utente (già accettate)
      return 1
    else
      stages= Stage.joins(:journey).where("route_id = ? AND journeys.user_id = ? AND accepted IS NULL", route_id,hitch_hiker_id)
      if !stages.empty?  #ci sono tratte la cui prenotazione è ancora non accettata
        return 2
      else
        stages = Stage.joins(:journey).where("route_id = ? AND journeys.user_id = ? ", route_id,hitch_hiker_id)
        if stages.empty?  #non ci sono prenotazioni di quell'utente per la tratta
        return 3
        end
        end
    end
  end

  def self.booked(route_id,hitch_hiker_id)
    stages = Stage.joins(:journey).where("route_id = ? AND journeys.user_id = ? ", route_id,hitch_hiker_id)
  end

  def self.find_driver(route)
    driver = User.find_by(driver_id: route.driver_id)
  end

  def self.search(search)
    if search
      where(["citta_partenza LIKE ?" , "%#{search}%"])
    else
      all
    end
  end

  def self.find_user_name_for_chat(driver_id)
    User.where(:driver_id => driver_id).first
  end

  def find_pay_method(id, route2)
    if route2 == nil
      contanti2=true
    else
      contanti2=route2.contanti
    end
    if self.contanti && contanti2
      where_clause = 'user_id = ? OR user_id = 0'
    else
      where_clause = 'user_id = ?'
    end
    PayMethods.where(where_clause, id)
  end

  def self.first_route(route1,route2)
    if route1.citta_arrivo.eql?(route2.citta_partenza)
      return true
    else
      return false
    end
  end

end
