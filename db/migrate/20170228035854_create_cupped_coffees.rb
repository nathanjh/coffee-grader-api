class CreateCuppedCoffees < ActiveRecord::Migration[5.0]
  def change
    create_table :cupped_coffees do |t|
      t.datetime :roast_date
      t.string :coffee_alias
      t.references :coffee, foreign_key: true
      t.references :roaster, foreign_key: true
      t.references :cupping, foreign_key: true

      t.timestamps
    end
  end
end
