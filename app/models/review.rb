class Review < ApplicationRecord
	validates :rating, 
    presence: true, 
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 5,
    }
  validates :commento, presence: true
  validates :data, presence: true
  
  belongs_to :driver
end
