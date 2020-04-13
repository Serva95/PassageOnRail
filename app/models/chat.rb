class Chat < ApplicationRecord
	has_many :messagges, dependent: :destroy

	belongs_to :user_1, class_name: 'User', foreign_key: "user_1_id"
	belongs_to :user_2, class_name: 'User', foreign_key: "user_2_id"

	def self.find_chats(user_id)
		Chat.joins(:user_1, :user_2).where("user_1_id = ? and deleted_user_1 = ? ", user_id, false).or(Chat.joins(:user_1, :user_2).where("user_2_id = ? and deleted_user_2 = ? ", user_id, false)).order(updated_at: :desc)
	end

	# @param [Integer] id_1
	# @param [Integer] id_2
	def self.exists(id_1, id_2)
		Chat.where("user_1_id = ? and user_2_id = ?", id_1, id_2).or(Chat.where("user_1_id = ? and user_2_id = ?", id_2, id_1)).first
	end

	# @note chat = la chat da modificare, side = user_1 o 2, value = valore di deleted della chat
	# @param [Chat] chat
	# @param [Integer] side
	# @param [Boolean] value
	def self.delete_reset_side(chat, side, value)
		if side == 1
			chat.update_columns(deleted_user_1: value)
		elsif side == 2
			chat.update_columns(deleted_user_2: value)
		end
	end
end
