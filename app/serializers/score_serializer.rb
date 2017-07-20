class ScoreSerializer < ActiveModel::Serializer
  attributes :id, :grader_id, :cupping_id, :cupped_coffee_id,
             :aroma, :aftertaste, :acidity, :body, :uniformity,
             :flavor, :balance, :clean_cup, :sweetness, :overall,
             :defects, :total_score, :final_score, :notes
  # belongs_to :grader
end
