class RouteNPValidator < ActiveModel::Validator
  def validate(record)
    if record.n_passeggeri.blank?
      record.errors[:n_passeggeri] << "Non può essere nil"
      elsif record.n_passeggeri > Vehicle.estrai_posti(record.vehicle_id)
        record.errors[:n_passeggeri] << "La macchina è piena"
    end
  end
end

class Route < ApplicationRecord
  validates :citta_partenza, presence: true
  validates :luogo_ritrovo, presence: true
  validates :data_ora_partenza, presence: true
  validates :citta_arrivo, presence: true
  validates :data_ora_arrivo, presence: true
  validates :costo, presence: true
  validates_with RouteNPValidator
  #validates :n_passeggeri, presence: true

	belongs_to :driver
	belongs_to :vehicle

  has_many :multi_trip_associations, dependent: :destroy
  has_many :multi_trips, :through => :multi_trip_associations, dependent: :destroy, inverse_of: :route
  has_many :passenger_associations, dependent: :destroy
  has_many :hitch_hikers, :through => :passenger_associations, dependent: :destroy, inverse_of: :route

  scope :current_passengers, -> (route_id) do
    select('n_passeggeri').where('id = ?', route_id)
  end

  def self.sum_passengers(route_id, n_passeggeri)
    route = Route.current_passengers(route_id)
    route.first.n_passeggeri + n_passeggeri
  end

  def self.search(search)
    if search
      where(["citta_partenza LIKE ?" , "%#{search}%"])
    else
      all
    end
  end


end
