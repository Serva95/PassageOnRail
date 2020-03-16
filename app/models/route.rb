class Route < ApplicationRecord
  validates :citta_partenza, presence: true
  validates :luogo_ritrovo, presence: true
  validates :data_ora_partenza, presence: true
  validates :citta_arrivo, presence: true
  validates :data_ora_arrivo, presence: true
  validates :costo, presence: true
  validates :n_passeggeri, presence: true

	belongs_to :driver
	belongs_to :vehicle

  has_many :multi_trip_associations, dependent: :destroy
  has_many :multi_trips, :through => :multi_trip_associations, dependent: :destroy
  has_many :passenger_associations, dependent: :destroy
  has_many :hitch_hikers, :through => :passenger_associations, dependent: :destroy

  #scope :journey, ->(driver_id) do
  #  where('driver_id = ?', driver_id)
  #end

  #def self.search(cp,ca)
   # where('citta_partenza = ? AND citta_arrivo = ?', cp,ca)
  #end

  def self.search(search)
    if search
      where(["citta_partenza LIKE ?" , "%#{search}%"])
    else
      all
    end
  end
end
