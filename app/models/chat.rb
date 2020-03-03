class Chat < ApplicationRecord
	has_many :messagges
	
	belongs_to :driver
	belongs_to :hitch_hiker
end
