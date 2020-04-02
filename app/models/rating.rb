class Rating < ApplicationRecord
	validates :vote,
    presence: true, 
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 5,
    }
	validates :data, presence: true
	
	belongs_to :driver
	belongs_to :user
end

def self.error_one
	return "Errore nel voto, non puoi dare un voto se ne hai già dato uno in precedenza"
end

def self.error_two
	return "Errore nel voto, controlla tutti i campi e prova ancora"
end