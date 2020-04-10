class PayMethodsDOBValidator < ActiveModel::Validator
  def validate(record)
    if record.intestatario.blank? or record.numero.blank?  or record.mese.blank? or record.anno.blank? or record.cvv.blank?
      record.errors[:testo] << "Devi compilare tutti i campi!"
    end
  end
end

class PayMethods < ApplicationRecord
  validates :intestatario, presence: true
  validates :numero, presence: true
  validates :mese_scadenza, presence: true
  validates :anno_scadenza, presence: true
  validates :cvv, presence: true

  belongs_to :user
end
