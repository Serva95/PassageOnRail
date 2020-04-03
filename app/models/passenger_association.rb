class PassengerAssociation < ApplicationRecord
	belongs_to :route, dependent: :destroy
	belongs_to :user, dependent: :destroy

	validates :n_prenotati, presence: true
	validates_uniqueness_of :route_id, scope: [:user_id]

	# transazione che aggiorna il numero di passeggeri in tratte e inserisce un'associazione
	# tra utente e tratta
	def self.on_create(id, passeggeri, user_id)
		self.transaction do
			@route = Route.find(id)
			@route.update!(n_passeggeri: passeggeri)
			@route.passenger_associations.create!(user_id: user_id, n_prenotati: passeggeri)
		end
	end

end
