class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :username, :email
  attribute :invite_token, if: -> { object.invite_token }
  attribute :image, if: -> { object.image }
end
