class Coffee < ApplicationRecord
  validates_presence_of :name, :farm, :origin
  validates :name, uniqueness: { scope: [:origin, :farm] }
end
