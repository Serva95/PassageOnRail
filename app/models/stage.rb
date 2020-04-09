class Stage < ApplicationRecord
  belongs_to :route
  belongs_to :journey, dependent: :destroy
end
