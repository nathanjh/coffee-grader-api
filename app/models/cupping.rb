class Cupping < ApplicationRecord
  belongs_to :host, foreign_key: 'host_id', class_name: 'User'
  has_many :invites, dependent: :destroy
  has_many :scores, dependent: :restrict_with_exception
  has_many :cupped_coffees, dependent: :destroy
  validates_presence_of :location, :cup_date, :cups_per_sample, :host_id
end
