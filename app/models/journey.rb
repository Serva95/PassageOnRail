class Journey < ApplicationRecord
	belongs_to :user, dependent: :destroy
	validates :n_prenotati, presence: true

	has_many :stages, inverse_of: :journey, dependent: :destroy
	has_many :routes, through: :stages
	accepts_nested_attributes_for :stages

	# transazione che aggiorna il numero di passeggeri, crea l'associazione user-journey e
	# le associazioni journey-stages
	def self.booking(journey, p)
		self.transaction do
			route = Route.find(journey.stages.first.route_id)
			route.update!(n_passeggeri: p)
			journey.save!
		end
	end

end
