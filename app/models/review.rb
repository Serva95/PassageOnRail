class ReviewDOBValidator < ActiveModel::Validator
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

  validates_with (ReviewDOBValidator)

  belongs_to :driver
  belongs_to :user

  def self.has_previous_journey_done(user_id, driver_id)
    journeys = Stage.joins(:journey, :route).where('journeys.user_id = ? and routes.driver_id=?', user_id, driver_id).order('routes.data_ora_arrivo')
    if journeys.present?
      journeys.each do |j|
        if j.route.data_ora_arrivo.utc < DateTime.now.utc
          return true
        end
      end
      return false
    end
  end

  def self.exists(current_user_id, user_driver_id)
    Review.where("user_id = ? and driver_id = ?", current_user_id, user_driver_id).exists?
  end

  def self.find_user(user_id)
    User.joins(:driver).find(user_id)
  end

  def self.find_reviews(driver_id)
    Review.joins(:user).where("reviews.driver_id = ?", driver_id).order(data: :desc)
  end

  def self.error_one
    return "Errore nella recensione, non puoi scrivere una nuova recensione se ne esiste già una a nome tuo"
  end

  def self.error_two
    return "Errore nella recensione, controlla tutti i campi e prova ancora"
  end
end