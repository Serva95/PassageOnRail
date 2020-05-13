class ReviewValidator < ActiveModel::Validator
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

  validates_with(ReviewValidator)

  belongs_to :driver
  belongs_to :user

  # @author serva
  #
  # @note crea la review a database, calcola la media con la nuova review e aggiorna il dato nella row del driver
  def self.new_review_transaction(review)
    ActiveRecord::Base.transaction do
      review.save!
      media = Review.where("driver_id = ?", review.driver_id).average(:vote)
      driver = Driver.find(review.driver_id)
      driver.update!(rating_medio: media)
    end
  end

  # @author serva
  #
  # @note esiste già una recensione a DB da parte di quell'utente per quel diver ?
  #
  # @return [TrueClass, FalseClass]
  #
  # @param [Numeric] current_user_id
  # @param [Numeric] user_driver_id
  def self.exists(current_user_id, user_driver_id)
    Review.where("user_id = ? and driver_id = ?", current_user_id, user_driver_id).exists?
  end

  # @author serva
  #
  # @note trova l'utente in join con il dirver che abbia quell'id passato
  #
  # @param [Numeric] user_id
  def self.find_user(user_id)
    User.joins(:driver).find(user_id)
  end

  # @author serva
  #
  # @note trova tutte le review associate al driver con id passato
  #
  # @param [Numeric] driver_id
  def self.find_reviews(driver_id)
    Review.joins(:user).where("reviews.driver_id = ?", driver_id).order(data: :desc)
  end

  # per testo errore
  def self.error_one
    return "Errore nella recensione, non puoi scrivere una nuova recensione se ne esiste già una a nome tuo"
  end

  # per testo errore
  def self.error_two
    return "Errore nella recensione, controlla tutti i campi e prova ancora"
  end
end