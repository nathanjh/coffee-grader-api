class UserShowSerializer < ActiveModel::Serializer
  attributes :id, :name, :username, :email

  has_many :invites
  has_many :attended_cuppings
  has_many :hosted_cuppings
  class InviteSerializer < ActiveModel::Serializer
    attributes :status, :cupping_id

    belongs_to :cupping
  end
end
