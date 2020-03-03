class AddDriverRefToRoutes < ActiveRecord::Migration[6.0]
  def change
    add_reference :routes, :driver, foreign_key: true
  end
end
