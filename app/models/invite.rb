class Invite < ApplicationRecord
  belongs_to :cupping
  belongs_to :grader, foreign_key: 'grader_id',
                      class_name: 'User',
                      optional: true

  enum status: [
    :pending,
    :accepted,
    :declined,
    :maybe
  ]

  validates :grader_id,
            uniqueness: { scope: :cupping_id,
                          message:
                          'has already been invited to this cupping' },
            allow_blank: true

  validates :grader_email,
            format: { with: /\A[^@\s]+@([^@\s.]+\.)+[^@\W]+\z/ },
            allow_blank: true
end
