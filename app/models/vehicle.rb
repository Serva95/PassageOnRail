class Vehicle < ApplicationRecord
	validates :targa, presence: true, uniqueness: true
	validates :posti, presence: true
	validates :comfort, presence: true
	
	has_many :routes, dependent: :destroy
	belongs_to :driver

	TIPI = ['Altro','Berlina', 'Cabriolet', 'Camper', 'Coupé', 'Fuoristrada', 'Monovolume', 'Pick up', 'Pulmino', 'Roadster', 'Station wagon', 'SUV']

	#estrai il numero di posti
	scope :max_passeggeri, -> (vehicle_id)  do
		select('posti').where('id = ?', vehicle_id)
	end

	#restitusce il numeri di posti
	def self.estrai_posti(veh)
		vehicle = Vehicle.max_passeggeri(veh)
		vehicle.first.posti
	end
end
