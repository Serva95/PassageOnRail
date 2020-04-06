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
    rating=driver.rating_medio
    return rating
  end

  def find_journey(id)
    Journey.where('user_id = ?', id)
  end

  belongs_to :driver, optional: true, dependent: :destroy
  has_many :chats
  has_many :messagges
  has_many :journeys
end
