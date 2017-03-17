class CuppedCoffee < ApplicationRecord
  belongs_to :coffee
  belongs_to :roaster
  belongs_to :cupping
  has_many :scores
  validates_presence_of :roast_date
  validates_uniqueness_of :coffee_alias, scope: :cupping_id
end
