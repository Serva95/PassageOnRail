class RouteNPValidator < ActiveModel::Validator
  def validate(record)
    if record.n_passeggeri.blank?
      record.errors[:n_passeggeri] << "Non può essere nil"
      #non si possono aggiungere più passeggeri dei posti diponibili nella macchina
      elsif record.n_passeggeri > Vehicle.max_passengers(record.vehicle_id)
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

  # Calcola il massimo numero di posti disponibili per una tratta
  def posti_disponibili
    self.vehicle.posti - self.n_passeggeri
  end

  # Data una route, trova tutti i passeggeri prenotati
  def find_passengers
    @journeys = Journey.includes("stages").where(stages: {route_id: self.id, accepted: true})
    @passengers = []
    @journeys.each do |journey|
      @passengers << journey.user
    end
  end

  # Data una route, trova tutte le journey a cui appartiene
  def find_journeys(route_id)
    journeys = Journey.joins(:stages).where("route_id = ?", route_id)
  end

  def self.booked(route_id,hitch_hiker_id)
    Stage.joins(:journey).where("route_id = ? AND journeys.user_id = ? ", route_id,hitch_hiker_id)
  end

  # Carica il profilo del driver
  def self.find_driver(route)
    User.find_by(driver_id: route.driver_id)
  end

  # def self.search(search)
  # if search
  #   where(["citta_partenza LIKE ?" , "%#{search}%"])
  # else
  #   all
  # end
  # end

  # estrae i metodi di pagamento di un utente controllando se è possibile pagare in contanti su tutte le tratte
  def self.find_pay_method(id, routes)
    if routes.inject(true) {|x,y| x && y.contanti}
      where_clause = 'user_id = ? OR user_id = 0'
    else
      where_clause = 'user_id = ?'
    end
    PayMethods.where(where_clause, id)
  end

  #date due route di una multitratta, ritorna true se quella passata come primo parametro è antecedente all'altra
  def self.first_route(route1,route2)
    if route1.citta_arrivo.eql?(route2.citta_partenza)
      return true
    else
      return false
    end
  end

  # Controlla se due tratte del multiviaggio si sovrappongono
  def self.overlying(route1,route2)
    if route1.data_ora_arrivo > route2.data_ora_partenza
      return true
    else
      return false
    end
  end

  # Decrementa il numero di passeggeri
  def self.decrease(route_id, n_passeggeri)
    route = Route.find(route_id)
    p = route.n_passeggeri - n_passeggeri
    route.update!(n_passeggeri: p)
  end

  # Elimina la route del driver e tutte le relative prenotazioni
  def self.destroy_route_and_stages(route,current_user)

    self.transaction do
      route.update(deleted: true)

      journeys = Route.find_journeys(route.id)
      journeys.each do |journey|
        number_of_stages = Stage.where("journey_id = ?", journey.id).count("id")
        if number_of_stages == 1
          Journey.create_notifications_th(journey.user_id, current_user, route, route, "delete_trip")
          journey.destroy! #la journey era composta da un solo stage, quindi elimino la journey e a cascata si elimina lo stage
        end
        # verificare se è possibile mettere la seconda parte dentro il ciclo
      end

      stages = Stage.where(route_id: route.id)
      stages.each do |stage|
        journey = stage.journey
        second_route = Route.find_second_stage(journey, route.id)
        Journey.create_notifications_th(stage.journey.user_id, current_user, route, second_route, "delete_multitrip")
      end
      stages.destroy_all #se la journey è composta da 2 stages, elimino solo quello di cui è stata cancellata la route e mantengo la journey con l'altro stage
    end
  end

  # Data una route e una journey multitratta a cui appartiene, trova lo stage dell'altra route della stessa journey
  def self.find_second_stage(journey, route_id)
    journey.stages.where("route_id != ?", route_id).first.route
  end

  # @param [Numeric] user_id
  # @param [Numeric] route_id
  # @param [Numeric] j_id
  def self.find_associated_stage(route_id, user_id, j_id)
    Stage.joins(:journey).where("route_id = ? and user_id = ? and journey_id = ?", route_id, user_id, j_id).any?
  end

end
