class MessaggeDOBValidator < ActiveModel::Validator
	def validate(record)
		if record.testo.blank?
			record.errors[:testo] << "Il messaggio non può essere vuoto"
		end
	end
end

class Messagge < ApplicationRecord
	validates :data_ora, presence: true
	validates :mittente, presence: true
	validates :destinatario, presence: true

	belongs_to :chat

	validates_with (MessaggeDOBValidator)
end