class AddFinalScoreAndFlavorToScores < ActiveRecord::Migration[5.0]
  def change
    add_column :scores, :final_score, :decimal
    add_column :scores, :flavor, :decimal
  end
end
