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

	# Cerca una precisa prenotazione
	# ha fallito i test, in realtà include tutti gli stage
	# proprio pre questo credo che non venga utilizzata da nessuna parte
	#scope :find_stage, -> (journey_id, driver_id, route_id) do
	#	includes("stages", "routes").where(id: journey_id, routes: {id: route_id, driver_id: driver_id})
	#end

	# Cerca i journey che hanno uno stage relativo a una route di un dato guidatore
	# che devono essere accettati/rifiutati
	scope :find_requests, -> (driver_id) do
		includes("user","stages", "routes").where(stages: {accepted: nil} ,routes: {driver_id: driver_id})
	end

	#è inutile anche questo metodo
	#scope :find_from_stage, -> (journey_id,state) do
	#	includes("stages", "routes").where(id: journey_id, stages: {accepted: state})
	#end

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
		# route.data_ora_partenza - 2.day > DateTime.current || route.data_ora_partenza - 2.day < route.update_at
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
	# @author sara e serva
	#
	# data una multitratta, cancella l'intera journey (quindi entrambi gli stages)

	def self.delete_journey(journey, route)
		ActiveRecord::Base.transaction do
			route.each do |r|
				r.decrement!(:n_passeggeri, by = journey.n_prenotati)
			end
			journey.destroy!
		end
	end

end
