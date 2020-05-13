class MessaggeValidator < ActiveModel::Validator
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

	validates_with(MessaggeValidator)

	# @author serva
	#
	# @note aggiorna l'orario di apertura della chat da parte dell'utente che l'ha aperta (per notifiche)
	#
	# @param [DateTime] update_time
	# @param [Numeric] chat_id
	# @param [Numeric] user_id
	def self.update_open_time(update_time, chat_id, user_id)
		chat = Chat.find(chat_id)
		if chat.user_1_id == user_id
			chat.update_columns(open_time_user_1: update_time)
		else
			chat.update_columns(open_time_user_2: update_time)
		end
	end

	# @author serva
	#
	# @note controlla quale lato della chat appartiene all'utente che ha inviato il messaggio,
	# @note salva il nuovo messaggio inviato,
	# @note aggiorna l'orario di ultima modifica e l'orario di apertura dell'utente che ha mandato il msg
	#
	# @param [Messagge] msg
	# @param [DateTime] update_time
	# @param [Chat] chat
	# @param [Numeric] user_id
	def self.new_msg_transaction(msg, update_time, chat, user_id)
		if chat.user_1_id == user_id
			ActiveRecord::Base.transaction do
				msg.save!
				chat.update!(updated_at: update_time, open_time_user_1: update_time)
				if chat.deleted_user_1 || chat.deleted_user_2
					Chat.delete_reset_side(chat, 1, false)
					Chat.delete_reset_side(chat, 2, false)
				end
				after_commit do
					return true
				end
			end
		else
			ActiveRecord::Base.transaction do
				msg.save!
				chat.update!(updated_at: update_time, open_time_user_2: update_time)
				if chat.deleted_user_1 || chat.deleted_user_2
					Chat.delete_reset_side(chat, 2, false)
					Chat.delete_reset_side(chat, 1, false)
				end
				after_commit do
					return true
				end
			end
		end
	end

	# @author serva
	#
	# @note cerca se esiste la chat con id chat_id, se esiste ->
	# @note cerca la chat relativa e controlla se l'utente che ha chiesto la chat ne è parte, se ne è parte ->
	# @note cerca tutti i messaggi appartenenti alla chat e li mostra
	# @note se limit è nil mostra solo i primi 15 messaggi, altrimenti tutti
	#
	# @param [Numeric] chat_id
	# @param [Numeric] user_id
	# @param [Numeric, NilClass] limit
	def self.find_messages(chat_id, user_id, limit)
		exists_one = Chat.exists?(chat_id)
		if exists_one
			extract = Chat.find(chat_id)
			if extract.user_1_id == user_id || extract.user_2_id == user_id
				if limit.nil?
					query = Messagge.joins(:user, :chat).where("chat_id = ?", chat_id).select("messagges.*", "user_1_id", "user_2_id").order(data_ora: :asc)
				else
					query = Messagge.joins(:user, :chat).where("chat_id = ?", chat_id).select("messagges.*", "user_1_id", "user_2_id").order(data_ora: :asc).last(15)
				end
				return query
			else
				return "forbidden"
			end
		else
			return "nothing"
		end
	end

	# @author serva
	#
	# @note cerca i nomi e i cognomi dei partecipanti alla chat per la pagina dei messaggi
	#
	# @param [Numeric] chat_id
	# @param [Numeric] current_user_id
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