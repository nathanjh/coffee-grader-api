class AddNullConstraintsToScores < ActiveRecord::Migration[5.0]
  def change
    change_column_null :scores, :aroma, false
    change_column_null :scores, :aftertaste, false
    change_column_null :scores, :acidity, false
    change_column_null :scores, :body, false
    change_column_null :scores, :uniformity, false
    change_column_null :scores, :balance, false
    change_column_null :scores, :clean_cup, false
    change_column_null :scores, :sweetness, false
    change_column_null :scores, :overall, false
    change_column_null :scores, :flavor, false
    change_column_null :scores, :total_score, false
    change_column_null :scores, :defects, false
    change_column_null :scores, :final_score, false
    change_column_null :scores, :grader_id, false
    change_column_null :scores, :cupping_id, false
    change_column_null :scores, :cupped_coffee_id, false
  end
end
