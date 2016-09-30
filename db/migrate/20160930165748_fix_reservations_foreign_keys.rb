class FixReservationsForeignKeys < ActiveRecord::Migration[5.0]
  def change
    remove_column :reservations, :suite_id
    remove_column :reservations, :client_id
    add_column :reservations, :suite_id, :integer
    add_column :reservations, :client_id, :integer
    add_foreign_key :reservations, :suites, on_delete: :cascade
    add_foreign_key :reservations, :clients, on_delete: :cascade
  end
end
