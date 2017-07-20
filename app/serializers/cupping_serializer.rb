class CuppingSerializer < ActiveModel::Serializer
  attributes :id, :location, :cup_date, :cups_per_sample, :host_id, :open

  has_many :cupped_coffees
  has_many :scores
  has_many :invites
end
