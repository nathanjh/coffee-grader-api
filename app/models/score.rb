class Score < ApplicationRecord
  belongs_to :grader, foreign_key: 'grader_id', class_name: 'User'
  belongs_to :cupped_coffee
  belongs_to :cupping

  validates_presence_of :grader_id,
                        :cupping_id,
                        :cupped_coffee_id,
                        :aroma,
                        :aftertaste,
                        :acidity,
                        :body,
                        :uniformity,
                        :flavor,
                        :balance,
                        :clean_cup,
                        :sweetness,
                        :overall,
                        :defects,
                        :total_score,
                        :final_score
end
