class CreateInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :invites do |t|
      t.references :cupping, foreign_key: true
      t.references :grader, foreign_key: { to_table: :users }
      t.integer :status

      t.timestamps
    end
  end
end
