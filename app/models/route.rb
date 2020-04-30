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

class RouteDateValidator < ActiveModel::Validator
  def validate(record)
    if record.data_ora_arrivo < record.data_ora_partenza
      record.errors[:data_ora_arrivo] << "La data di arrivo non può essere antecedente alla data di partenza"
    end
    if record.data_ora_partenza < Date.today
      record.errors[:data_ora_partenza] << "La data di partenza non può essere antecedente alla data di oggi"
    end
    if record.data_ora_arrivo < Date.today
      record.errors[:data_ora_arrivo] << "La data di partenza non può essere antecedente alla data di oggi"
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
  validates_with RouteDateValidator
  #validates :n_passeggeri, presence: true

	belongs_to :driver
	belongs_to :vehicle

  has_many :stages, dependent: :destroy
  has_many :journeys, :through => :stages
  has_many :notifications, as: :second_target, dependent: :destroy

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

  # def self.search(search)
  # if search
  #   where(["citta_partenza LIKE ?" , "%#{search}%"])
  # else
  #   all
  # end
  # end

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

  # decrementa il numero di passeggeri
  def self.decrease(route_id, n_passeggeri)
    route = Route.find(route_id)
    p = route.n_passeggeri - n_passeggeri
    route.update!(n_passeggeri: p)
  end

  def self.destroy_route_and_stages(route,current_user)
    self.transaction do
      route.update(deleted: true)
      journeys = Route.find_journeys(route.id)
      journeys.each do |journey|
        Journey.create_notifications_th(journey,current_user,"deleted")
        number_of_stages = Stage.where("journey_id = ?", journey.id).count("id")
        if number_of_stages == 1
          journey.destroy! #la journey era composta da un solo stage, quindi elimino la journey e a cascata si elimina lo stage
        end
      end
      Stage.where(route_id: route.id).destroy_all #se la journey è composta da 2 stages, elimino solo quello di cui è stata cancellata la route e mantengo la journey con l'altro stage
    end
  end

end
