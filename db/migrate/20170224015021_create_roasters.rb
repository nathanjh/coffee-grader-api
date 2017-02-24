class CreateRoasters < ActiveRecord::Migration[5.0]
  def change
    create_table :roasters do |t|
      t.string :name
      t.string :location
      t.string :website

      t.timestamps
    end
  end
end
