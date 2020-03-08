class Vehicle < ApplicationRecord
	validates :targa, presence: true, uniqueness: true
	validates :posti, presence: true
	validates :comfort, presence: true
	
	has_many :routes, dependent: :destroy
	belongs_to :driver
end
