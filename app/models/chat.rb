class Chat < ApplicationRecord
	has_many :messagges, dependent: :destroy
	
	belongs_to :driver
	belongs_to :hitch_hiker
end
