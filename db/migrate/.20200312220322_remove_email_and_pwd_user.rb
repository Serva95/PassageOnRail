class RemoveEmailAndPwdUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :email, :varchar
    remove_column :users, :password, :varchar
  end
end
