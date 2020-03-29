class ChangeReferenceTripAssociation < ActiveRecord::Migration[6.0]
  def change
    remove_column :passenger_associations, :hitch_hiker_id, :integer
    add_reference :passenger_associations, :user, foreign_key: true

  end
end
