require 'carrierwave/orm/activerecord'

class UserDOBValidator < ActiveModel::Validator
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
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates_with UserDOBValidator

  mount_uploader :avatar, AvatarUploader

  #recupero il rating medio del driver
  def find_rating_driver
    driver=Driver.find(self.driver_id)
    driver.rating_medio
  end

  #recupero tutte le tratte singole prenotate dall'utente
  def find_bookings(user_id)
    where_clause = 'journeys.user_id = ?'
    Journey.includes(:stages, :routes).where(where_clause, user_id)
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
