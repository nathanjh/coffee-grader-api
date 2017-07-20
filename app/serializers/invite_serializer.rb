class InviteSerializer < ActiveModel::Serializer
  attributes :id, :status, :cupping_id, :grader_id, :grader_email, :invite_token

  belongs_to :grader
end
