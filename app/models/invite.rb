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

  # NOTE: invite must be instantiated with either a grader_id or grader_email...
  validates_presence_of :grader_id, if: -> { grader_email.blank? }
  validates_presence_of :grader_email, if: -> { grader_id.blank? }

  validates_uniqueness_of :grader_id,
                          scope: :cupping_id,
                          message: 'has already been invited to this cupping',
                          allow_blank: true

  validates_format_of :grader_email, with: /\A[^@\s]+@([^@\s.]+\.)+[^@\W]+\z/,
                                     allow_blank: true
end
