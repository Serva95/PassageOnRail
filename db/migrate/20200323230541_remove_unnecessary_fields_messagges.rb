class RemoveUnnecessaryFieldsMessagges < ActiveRecord::Migration[6.0]
  def change
    remove_columns(:messagges, :created_at, :updated_at)
    change_column_null(:messagges, :testo, false)
    change_column_null(:messagges, :data_ora, false)
  end
end
