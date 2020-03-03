class MultiTrip < ApplicationRecord
	validates :data_ora_partenza, presence: true
    validates :citta_partenza, presence: true
    validates :data_ora_arrivo, presence: true
    validates :citta_arrivo, presence: true
    validates :costo_totale, presence: true
    validates :comfort_medio, presence: true
    validates :numero_cambi, presence: true
	
	has_many :multi_trip_associations
	has_many :single_trips, :through => :multi_trip_associations
end
