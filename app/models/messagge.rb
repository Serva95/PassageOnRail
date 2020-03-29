class MessaggeDOBValidator < ActiveModel::Validator
	def validate(record)
		if record.testo.blank?
			record.errors[:testo] << "Il messaggio non può essere vuoto"
		end
	end
end

class Messagge < ApplicationRecord
	validates :data_ora, presence: true
	validates :user_id, presence: true

	belongs_to :chat, required: true
	belongs_to :user, required: true

	validates_with (MessaggeDOBValidator)

	def self.find_messages(chat_id, user_id)
		exists_one = Chat.exists?(chat_id)
		if exists_one
			extract = Chat.find(chat_id)
			if extract.present?
				if extract.user_1_id == user_id || extract.user_2_id == user_id
					query = Messagge.joins(:user, :chat).where("chat_id = ?", chat_id).select("messagges.*","user_1_id","user_2_id").order(data_ora: :asc).last(15)
					#da implementare in futuro se si vuole notifiche una tabella o due campi con datetime di apertura per ogni user
					#extract.update_column(:opened_at, DateTime.current)
					return query
				else
					return "forbidden"
				end
			end
		else
			return "nothing"
		end
	end

	def self.find_chatters(chat_id, current_user_id)
		chatter_params = Chat.joins(:user_1, :user_2).select("users.id as id1", "users.nome as n1", "users.cognome as cn1", "user_2s_chats.id as id2", "user_2s_chats.nome as n2", "user_2s_chats.cognome as cn2").find(chat_id)
		if chatter_params.present?
			if chatter_params.id1 == current_user_id
				chatter = [chatter_params.n2, chatter_params.cn2]
			else
				chatter = [chatter_params.n1, chatter_params.cn1]
			end
			return chatter
		else
			return "nothing"
		end
	end

end