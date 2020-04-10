class AddUserReferenceToPay < ActiveRecord::Migration[6.0]
  def change
    add_reference :pay_methods, :user, foreign_key: true
  end
end
