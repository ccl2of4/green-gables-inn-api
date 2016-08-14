class RemoveFieldNameFromSuites < ActiveRecord::Migration[5.0]
  def change
    remove_column :suites, :description, :string
  end
end
