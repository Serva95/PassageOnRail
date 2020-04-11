class PayMethodsDOBValidator < ActiveModel::Validator
  def validate(record)
    anno = record.anno_scadenza + 2000
    if anno == Time.new.year and record.mese_scadenza < Time.new.month
      record.errors[:error] << "Data di scadenza non valida"
    end
  end
end

class PayMethods < ApplicationRecord
  validates :intestatario, presence: true
  validates :numero, presence: true, format: { with: /\A[0-9]+\z/, message: "only allows number" }, length: { is: 16 }
  validates :mese_scadenza, presence: true, numericality: { only_integer: true }, inclusion: {in: 1..12}
  validates :anno_scadenza, presence: true, numericality: { only_integer: true }, inclusion: {in: Time.new.year-2000..(Time.new.year-1990)}
  validates :cvv, presence: true, format: { with: /\A[0-9]+\z/, message: "only allows number" }, length: { is: 3 }

  validates_with PayMethodsDOBValidator

  belongs_to :user
end
