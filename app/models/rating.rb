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
end
