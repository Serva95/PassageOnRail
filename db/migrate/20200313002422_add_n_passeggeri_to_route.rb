class AddNPasseggeriToRoute < ActiveRecord::Migration[6.0]
  def change
    add_column :routes, :n_passeggeri, :integer, default: 0
  end
end
