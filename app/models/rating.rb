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

	def self.find_ratings(user_id)
		Rating.joins('INNER JOIN "users" ON "users"."driver_id" = "ratings"."driver_id"').where("ratings.user_id = ?", user_id).select('"ratings".*','nome' ).order(data: :desc)
	end

	def self.exists(user_id, driver_id)
		Rating.where("user_id = ? and driver_id = ?", user_id, driver_id).exists?
	end

	def self.error_one
		return "Errore nel voto, non puoi dare un voto se ne hai già dato uno in precedenza"
	end

	def self.error_two
		return "Errore nel voto, controlla tutti i campi e prova ancora"
	end
end