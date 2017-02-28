class Cupping < ApplicationRecord
  belongs_to :user, optional: true
  validates_presence_of :location, :cup_date, :host_id
end
