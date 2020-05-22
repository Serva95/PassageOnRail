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
	has_many :notifications, as: :target, dependent: :destroy
	accepts_nested_attributes_for :stages

	# transazione che aggiorna il numero di passeggeri, crea l'associazione user-journey e
	# le associazioni journey-stages
	def booking
		self.transaction do
			for stage in self.stages do
				route = Route.find(stage.route_id)
				route.increment!(:n_passeggeri, by = self.n_prenotati)
			end
			self.save!
		end
	end

	# transaction che decrementa il numero di passeggeri e
	# setta a false la stage rifiutata
	def self.reject(n_passeggeri, stage)
		self.transaction do
			stage.route.decrement!(:n_passeggeri, n_passeggeri)
			stage.update!(accepted: false)
		end
	end

	def self.decrease_and_destroy(stage, n_passeggeri)
		self.transaction do
			stage.route.decrement!(:n_passeggeri, n_passeggeri)
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
	#
	# @author serva
	#
	# @note controlla se il viaggio è eliminabile secondo i vincoli temporali:
	# @note 48 ore o prima rispetto alla partenza,
	# @note sempre se il guidatore ha modificato il viaggio entro 48 dalla partenza
	# si potrebbe modificare e accorciare in un'unica riga di codice
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
	#
	# @author serva
	#
	# @note dato un oggetto journey e uno route da eliminare, controlla se ha uno o due stage,
	# @note se ne ha uno elimina il journey e decrementa il numero di passeggeri nella route
	# @note se ne ha due elimina il relativo stage e decrementa il numero di passeggeri nella route
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

	# @param [Journey] journey
	# @param [Route] route_1
	# @param [Route] route_2
	#
	# @author sara e serva
	#
	# data una multitratta, cancella l'intera journey (quindi entrambi gli stages)
	def self.delete_both_passage(journey, route_1, route_2)
		ActiveRecord::Base.transaction do
			journey.destroy!
			route_1.decrement!(:n_passeggeri, by = journey.n_prenotati)
			route_2.decrement!(:n_passeggeri, by = journey.n_prenotati)
		end
	end

end
