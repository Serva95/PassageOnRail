class Journey < ApplicationRecord
	belongs_to :user, dependent: :destroy
	validates :n_prenotati, presence: true

	has_many :stages, dependent: :destroy

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
