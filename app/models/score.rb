class Score < ApplicationRecord
  belongs_to :cupped_coffee, optional: true
  belongs_to :user, optional: true
  belongs_to :cupping
end
