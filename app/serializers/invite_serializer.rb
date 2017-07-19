class InviteSerializer < ActiveModel::Serializer
  attributes :id, :status, :cupping_id, :grader_id, :grader_email, :invite_token

  belongs_to :grader
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :name, :username, :email
  end
end
