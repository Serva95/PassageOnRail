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
end
