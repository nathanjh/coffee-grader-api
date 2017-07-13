class CreateCoffees < ActiveRecord::Migration[5.0]
  def change
    create_table :coffees do |t|
      t.string :name
      t.string :origin
      t.string :producer

      t.timestamps
    end
  end
end
