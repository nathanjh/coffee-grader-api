class Invite < ApplicationRecord
  belongs_to :cupping
  belongs_to :grader, foreign_key: 'grader_id', class_name: 'User'
  enum status: [
    :pending,
    :accepted,
    :declined,
    :maybe
  ]
end
