class CoffeeSerializer < ActiveModel::Serializer
  attributes :id, :name, :origin, :producer, :variety

  # has_many :cupped_coffees
  # has_many :roasters
end
