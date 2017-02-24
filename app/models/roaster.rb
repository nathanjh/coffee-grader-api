class Roaster < ApplicationRecord
  validates_presence_of :name, :location

  validates :name, uniqueness: { scope: :location }
end
