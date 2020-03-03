class Messagge < ApplicationRecord
	validates :data_ora, presence: true
	validates :testo, presence: true
	validates :mittente, presence: true
	validates :destinatario, presence: true
	
	belongs_to :chat
end
