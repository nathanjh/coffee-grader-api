class Coffee < ApplicationRecord
  validates_presence_of :name, :farm, :origin
  validates :name, uniqueness: { scope: [:origin, :farm] }

  has_many :cupped_coffees
  has_many :roasters, -> { distinct }, through: :cupped_coffees
end
