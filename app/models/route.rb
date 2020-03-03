class Route < ApplicationRecord
	validates :citta_partenza, presence: true
    validates :luogo_ritrovo, presence: true
    validates :data_ora_partenza, presence: true
    validates :citta_arrivo, presence: true
    validates :data_ora_arrivo, presence: true
    validates :costo, presence: true
	
	has_one :single_trip
	belongs_to :driver
	belongs_to :vehicle
end
