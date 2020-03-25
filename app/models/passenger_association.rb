class PassengerAssociation < ApplicationRecord
	belongs_to :route, dependent: :destroy
	belongs_to :hitch_hiker, dependent: :destroy

	validates :n_prenotati, presence: true

	# con queste due righe dovrebbe impedire ad un utente
	# di prenotare tratte già prenotate in precedenza
	add_index :passenger_association, [:route_id, :hitch_hiker_id], unique: true
	validates_uniqueness_of :route_id, scope: [:hitch_hiker_id]

end
