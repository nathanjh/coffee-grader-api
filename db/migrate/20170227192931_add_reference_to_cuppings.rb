class AddReferenceToCuppings < ActiveRecord::Migration[5.0]
  def change
    add_reference :cuppings, :host, foreign_key: { to_table: :users }
  end
end
