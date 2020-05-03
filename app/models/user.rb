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

  def find_rating_driver
    Review.where("driver_id = ?", self.driver_id).average(:vote)
  end

  def find_rating_autostoppista
    Rating.where("user_id = ?", self.id).average(:vote)
  end

  #recupero tutte le tratte singole prenotate dall'utente
  def find_bookings(user_id)
    Journey.includes(:stages, :routes).where(user_id:user_id, stages:{accepted:true})
        .or(Journey.includes(:stages, :routes).where(user_id:user_id, stages:{accepted:nil}))
        .order(data_ora_partenza: 'ASC')
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
