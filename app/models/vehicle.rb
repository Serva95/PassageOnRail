class Vehicle < ApplicationRecord
	validates :targa, presence: true, uniqueness: true
	validates :posti, presence: true
	validates :comfort, presence: true
	
	has_many :routes, dependent: :destroy
	belongs_to :driver

	TIPI = ['Altro','Berlina', 'Cabriolet', 'Camper', 'Coupé', 'Fuoristrada', 'Monovolume', 'Pick up', 'Pulmino', 'Roadster', 'Station wagon', 'SUV']

end
