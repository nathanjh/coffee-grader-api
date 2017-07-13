class CreateCuppings < ActiveRecord::Migration[5.0]
  def change
    create_table :cuppings do |t|
      t.string :location
      t.datetime :cup_date

      t.timestamps
    end
  end
end
