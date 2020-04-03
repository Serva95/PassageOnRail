class ReviewDOBValidator < ActiveModel::Validator
  def validate(record)
    if record.commento.blank?
      record.errors[:commento] << " non può essere vuoto"
    end
  end
end

class Review < ApplicationRecord
	validates :vote,
    presence: true, 
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 5,
    }
  validates :data, presence: true

  validates_with (ReviewDOBValidator)
  
  belongs_to :driver
  belongs_to :user
end

def self.error_one
  return "Errore nella recensione, non puoi scrivere una nuova recensione se ne esiste già una a nome tuo"
end

def self.error_two
  return "Errore nella recensione, controlla tutti i campi e prova ancora"
end
