class CreateReservations < ActiveRecord::Migration[5.0]
  def change
    create_table :reservations do |t|
      t.string :suite_id
      t.string :client_id
      t.datetime :start_date
      t.datetime :end_date
      t.string :price
      t.integer :number_of_people
      t.string :comments
      t.boolean :accepted

      t.timestamps
    end
  end
end
