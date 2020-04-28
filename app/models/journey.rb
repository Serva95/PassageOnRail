class JourneyUSValidator < ActiveModel::Validator
	def validate(record)
		if record.user_id.blank?
			record.errors[:user_id] << "Non può essere nil"
			# non si possono prenotare tratte
		elsif Route.booked(record.stages.first.route_id ,record.user_id).exists?
			record.errors[:user_id] << "Tratta già prenotata"
		end
	end
end

class Journey < ApplicationRecord
	validates_with JourneyUSValidator
	belongs_to :user
	validates :n_prenotati, presence: true

	has_many :stages, inverse_of: :journey, dependent: :destroy
	has_many :routes, through: :stages
	accepts_nested_attributes_for :stages

	# crea le notifiche per i driver delle route prenotate
	def self.create_notifications_td(journey, current_user)
		journey.stages.each do |stage|
			driver = Route.find_driver(stage.route)
			Notification.create! do |notification|
				notification.notify_type = "reservation"
				notification.actor = current_user
				notification.user = driver
				notification.target = journey
				notification.second_target = stage.route
			end
		end
	end

	# crea le notifiche per gli autostoppisti
	def self.create_notifications_th(journey, current_user, notify_type)
		journey.stages.each do |stage|
			user = User.find(journey.user_id)
			Notification.create! do |notification|
				notification.notify_type = notify_type
				notification.actor = current_user
				notification.user = user
				notification.target = journey
				notification.second_target = stage.route
			end
		end
	end

	# transazione che aggiorna il numero di passeggeri, crea l'associazione user-journey e
	# le associazioni journey-stages
	def self.booking(journey)
		self.transaction do
			for stage in journey.stages do
				route = Route.find(stage.route_id)
				p = route.n_passeggeri + journey.n_prenotati
				route.update!(n_passeggeri: p)
			end
			journey.save!
		end
	end

	# transaction che decrementa il numero di passeggeri e
	# setta a false la stage rifiutata
	def self.reject(n_passeggeri, stage)
		self.transaction do
			Route.decrease(stage.route_id, n_passeggeri)
			stage.update!(accepted: false)
		end
	end

	def self.decrease_and_destroy(stage, n_passeggeri)
		self.transaction do
			Route.decrease(stage.route_id, n_passeggeri)
			stage.destroy!
		end
	end

	# Cerca una precisa prenotazione
	def self.find_stage(journey_id, driver_id, route_id)
		Journey.includes("stages", "routes").where(id: journey_id, routes: {id: route_id, driver_id: driver_id})
	end

	# Cerca i journey che hanno uno stage relativa a una route di un dato guidatore
	def self.find_requests(driver_id)
		Journey.includes("user","stages", "routes").where(stages: {accepted: nil} ,routes: {driver_id: driver_id})
	end

	def self.find_from_stage(journey_id,state)
		Journey.includes("stages", "routes").where(id: journey_id, stages: {accepted: state})
	end

	# @param [Route] route
	# @return [TrueClass, FalseClass]
	def self.journey_is_deletable(route)
		if route.data_ora_partenza - 2.day > DateTime.current
			true
		elsif route.data_ora_partenza - 2.day < route.updated_at
			true
		else
			false
		end
	end

	# @param [Journey] journey
	# @param [Route] route
	def self.delete_passage_transaction(journey, route)
		number_of_stages = Stage.where("journey_id = ?", journey.id).count("id")
		if number_of_stages == 1
			ActiveRecord::Base.transaction do
				journey.destroy!
				route.decrement!(:n_passeggeri, by = journey.n_prenotati)
			end
		elsif number_of_stages == 2
			stage = Stage.where("journey_id = ? and route_id = ?", journey.id, route.id).first
			ActiveRecord::Base.transaction do
				stage.destroy!
				route.decrement!(:n_passeggeri, by = journey.n_prenotati)
			end
		end
	end

end
