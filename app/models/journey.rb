class Journey < ApplicationRecord
	belongs_to :user, dependent: :destroy
	validates :n_prenotati, presence: true

	has_many :stages, inverse_of: :journey, dependent: :destroy
	has_many :routes, through: :stages
	accepts_nested_attributes_for :stages

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

end
