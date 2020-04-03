class Stage < ApplicationRecord
  belongs_to :route, dependent: :destroy
  belongs_to :journey, dependent: :destroy
end
