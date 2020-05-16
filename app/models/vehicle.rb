class Vehicle < ApplicationRecord
	validates :targa, presence: true, uniqueness: true
	validates :posti, presence: true, numericality: {greater_than: 0, less_than: 9, only_integer: true}
	validates :comfort, presence: true, numericality: {greater_than: 0, less_than_or_equal_to: 10, only_integer: true}
	
	has_many :routes, dependent: :destroy
	belongs_to :driver

	TIPI = ['Altro','Berlina', 'Cabriolet', 'Camper', 'Coupé', 'Fuoristrada', 'Monovolume', 'Pick up', 'Pulmino', 'Roadster', 'Station wagon', 'SUV']

	#estrai il numero di posti
	scope :max_passengers, -> (vehicle_id)  do
		select('posti').where('id = ?', vehicle_id).first.posti
	end

end
