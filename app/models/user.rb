require 'carrierwave/orm/activerecord'

class UserValidator < ActiveModel::Validator
  def validate(record)
    if record.data_di_nascita.blank?
      record.errors[:data_di_nascita] << "campo obbligatorio?!"
    elsif record.data_di_nascita > 18.years.ago
      record.errors[:data_di_nascita] << "non accettabile (scusa, ma devi avere almeno 18 anni per iscriverti)"
    end
  end
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable
  validates_with UserValidator

  mount_uploader :avatar, AvatarUploader

  # Trova tutti i rating associati al driver e ne fa la media
  def find_rating_driver
    Review.where("driver_id = ?", self.driver_id).average(:vote)
  end

  # Trova tutti i rating dell'autospottista e ne fa la media
  def find_rating_autostoppista
    Rating.where("user_id = ?", self.id).average(:vote)
  end

  # Recupero tutte le tratte singole prenotate dall'utente
  def find_bookings(user_id)
    Journey.includes(:stages, :routes).where(user_id:user_id, stages:{accepted:true})
        .or(Journey.includes(:stages, :routes).where(user_id:user_id, stages:{accepted:nil}))
        .order(data_ora_partenza: 'ASC')
  end

  # @author serva
  #
  # @note controlla se il guidatore e l'autostoppista hanno viaggiato insieme in precedenza
  # @note questo per permettere di valutare solo dopo aver viaggiato insieme almeno una volta
  # @note (valido sia per rating che per review)
  #
  # @note spostata in user perché uguale sia in review.rb che rating.rb
  #
  # @param [Numeric] user_id
  # @param [Numeric] driver_id
  #
  # @return [TrueClass, FalseClass]
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

  belongs_to :driver, optional: true, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :pay_methods, inverse_of: :user, dependent: :destroy
  has_many :messagges
  has_many :journeys, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :notifications, foreign_key: :user_id
end
