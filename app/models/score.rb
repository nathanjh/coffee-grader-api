class Score < ApplicationRecord
  belongs_to :cupped_coffee
  belongs_to :grader
  belongs_to :cupping
end
