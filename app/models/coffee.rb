class Coffee < ApplicationRecord
  validates_presence_of :name, :producer, :origin
  validates :name, uniqueness: { scope: [:origin, :producer] }

  has_many :cupped_coffees
  has_many :roasters, -> { distinct }, through: :cupped_coffees
end
