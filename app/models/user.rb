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

  def find_rating_hitch()
    hitch=HitchHiker.find(self.hitch_hiker_id)
    rating=hitch.rating_medio
    return rating
  end
  def find_rating_driver()
    driver=Driver.find(self.driver_id)
    rating=driver.rating_medio
    return rating
  end




  belongs_to :driver, optional: true, dependent: :destroy
  belongs_to :hitch_hiker, optional: true, dependent: :destroy
  has_many :chats
  has_many :messagges
end
