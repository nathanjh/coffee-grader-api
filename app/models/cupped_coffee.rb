class CuppedCoffee < ApplicationRecord
  belongs_to :coffee
  belongs_to :roaster
  belongs_to :cupping

  validates_presence_of :roast_date
end
