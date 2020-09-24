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

	# Cerca i journey che hanno uno stage relativo a una route di un dato guidatore
	# che devono essere accettati/rifiutati
	scope :find_requests, -> (driver_id) do
		includes("user","stages", "routes").where(stages: {accepted: nil} ,routes: {driver_id: driver_id})
	end


	# controlla se il viaggio è eliminabile secondo i vincoli temporali:
	# 48 ore o prima rispetto alla partenza;
	# sempre, se il guidatore ha modificato il viaggio entro 48 dalla partenza
	# --- si potrebbe modificare e accorciare in un'unica riga di codice?
	def self.journey_is_deletable(route)
		route.data_ora_partenza - 2.day > DateTime.current || route.data_ora_partenza - 2.day < route.updated_at
	end

	# controlla se entrambe i viaggi di un multitratta sono eliminabili secondo i vincoli temporali:
	# 48 ore o prima rispetto alla partenza;
	# sempre, se il guidatore ha modificato il viaggio entro 48 dalla partenza
	def self.journey_both_deletable(journey, id)
		unless journey.user_id == id
			false
		end
		route_1 = Route.find(journey.stages[0].route_id)
		route_2 = Route.find(journey.stages[1].route_id)
		(route_1.data_ora_partenza - 2.day > DateTime.current || route_1.data_ora_partenza - 2.day < route_1.updated_at) && (route_2.data_ora_partenza - 2.day > DateTime.current || route_2.data_ora_partenza - 2.day < route_2.updated_at)
	end


	# data una multitratta, cancella l'intera journey (quindi entrambi gli stages)

	def self.delete_journey(journey, routes)
		ActiveRecord::Base.transaction do
			routes.each do |r|
				r.decrement!(:n_passeggeri, by = journey.n_prenotati)
			end
			journey.destroy!
		end
	end

end
