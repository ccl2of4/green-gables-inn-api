class CreateSuites < ActiveRecord::Migration[5.0]
  def change
    create_table :suites do |t|
      t.string :name
      t.string :description
      t.integer :price

      t.timestamps
    end
  end
end
