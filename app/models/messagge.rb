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

	belongs_to :chat, required: true
	belongs_to :user, required: true

	validates_with (MessaggeDOBValidator)

	def self.find_chats(chat_id)
		Messagge.joins(:user).where("chat_id = ?", chat_id)
	end

	def self.find_chatters(chat_id)
		Chat.joins(:user_1, :user_2).where("chats.id = ?", chat_id).limit(1).select("users.id as id1", "users.nome as n1", "users.cognome as cn1", "user_2s_chats.id as id2", "user_2s_chats.nome as n2", "user_2s_chats.cognome as cn2").first
	end

end