class AddHitchHikerRefToPassengerAssociations < ActiveRecord::Migration[6.0]
  def change
    add_reference :passenger_associations, :hitch_hiker, foreign_key: true
  end
end
