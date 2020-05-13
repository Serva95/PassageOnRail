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

	# @author serva
	#
	# @note crea il rating a database, calcola la media con il nuovo inserito e aggiorna il dato nella row dello user
  #
	# @param [Rating] rating
	def self.new_rating_transaction(rating)
		ActiveRecord::Base.transaction do
			rating.save!
			media = Rating.where("user_id = ?", rating.user_id).average(:vote)
			user = User.find(rating.user_id)
			user.update!(hitch_hiker_rating: media)
		end
	end

	# @author serva
	#
	# @note trova tutti i rating associati all'utente con id passato
	#
	# @param [Numeric] user_id
	def self.find_ratings(user_id)
		Rating.joins('INNER JOIN "users" ON "users"."driver_id" = "ratings"."driver_id"').where("ratings.user_id = ?", user_id).select('"ratings".*','nome' ).order(data: :desc)
	end

	# @author serva
	#
	# @note controlla se esiste già un rating da parte di quel driver a quello user (evita doppie valutazioni)
	#
	# @param [Numeric] driver_id
	# @param [Numeric] user_id
	def self.exists(user_id, driver_id)
		Rating.where("user_id = ? and driver_id = ?", user_id, driver_id).exists?
	end

	# per testo errore
	def self.error_one
		return "Errore nel voto, non puoi dare un voto se ne hai già dato uno in precedenza"
	end

	# per testo errore
	def self.error_two
		return "Errore nel voto, controlla tutti i campi e prova ancora"
	end
end