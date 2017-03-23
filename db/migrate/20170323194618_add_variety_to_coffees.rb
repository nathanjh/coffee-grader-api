class AddVarietyToCoffees < ActiveRecord::Migration[5.0]
  def change
    add_column :coffees, :variety, :string
  end
end
