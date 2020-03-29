class Chat < ApplicationRecord
	has_many :messagges, dependent: :destroy
	
	belongs_to :user_1, class_name: 'User', foreign_key: "user_1_id"
	belongs_to :user_2, class_name: 'User', foreign_key: "user_2_id"

	def self.find_chats(user_id)
		Chat.joins(:user_1, :user_2).where("user_1_id = ?", user_id).or(Chat.joins(:user_1, :user_2).where("user_2_id = ?", user_id )).order(updated_at: :desc)
	end

	def self.exists(id_1, id_2)
		Chat.where("user_1_id = ? and user_2_id = ?", id_1, id_2).or(Chat.where("user_1_id = ? and user_2_id = ?", id_2, id_1)).first
	end
end
