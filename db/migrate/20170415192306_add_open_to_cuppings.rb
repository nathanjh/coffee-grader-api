class AddOpenToCuppings < ActiveRecord::Migration[5.0]
  def change
    add_column :cuppings, :open, :boolean, default: true
  end
end
