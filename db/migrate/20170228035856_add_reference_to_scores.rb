class AddReferenceToScores < ActiveRecord::Migration[5.0]
  def change
    add_reference :scores, :grader, foreign_key: { to_table: :users }
  end
end
