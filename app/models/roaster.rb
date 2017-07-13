class Roaster < ApplicationRecord
  validates_presence_of :name, :location

  validates :name, uniqueness: { scope: :location }

  has_many :cupped_coffees
  has_many :coffees, -> { distinct }, through: :cupped_coffees
end
