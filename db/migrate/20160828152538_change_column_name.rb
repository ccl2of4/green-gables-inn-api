class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :reservations, :comments, :comment
  end
end
