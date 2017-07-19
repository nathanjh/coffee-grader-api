class CuppedCoffeeSerializer < ActiveModel::Serializer
  attributes :id, :roast_date, :coffee_alias,
             :coffee_id, :roaster_id, :cupping_id
  belongs_to :coffee
  belongs_to :roaster
  has_many :scores
end
