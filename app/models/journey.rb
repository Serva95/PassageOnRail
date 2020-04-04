class Journey < ApplicationRecord
	belongs_to :user, dependent: :destroy
	validates :n_prenotati, presence: true

	has_many :stages, dependent: :destroy
	accepts_nested_attributes_for :stages, reject_if: lambda {|attributes| attributes['route_id'].blank?}

	# transazione che aggiorna il numero di passeggeri, crea l'associazione user-journey e
	# le associazioni journey-stages
	def self.booking(journey, p)
		self.transaction do
			route = Route.find(journey.stages.route_id)
			route.update!(n_passeggeri: p)
			journey.save!
		end
	end

end
