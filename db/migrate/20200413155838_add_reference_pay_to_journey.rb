class AddReferencePayToJourney < ActiveRecord::Migration[6.0]
  def change
    add_reference :journeys, :pay_method, foreign_key: true
  end
end
