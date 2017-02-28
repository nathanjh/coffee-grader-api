class Cupping < ApplicationRecord
  belongs_to :host, foreign_key: "host_id", class_name: "User"
  validates_presence_of :location, :cup_date, :host_id
end
