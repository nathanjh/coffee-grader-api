class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  include DeviseTokenAuth::Concerns::User

  validates_presence_of :username, :email, :name
  validates_uniqueness_of :email
  validates_uniqueness_of :username, case_sensitive: false

  has_many :scores, foreign_key: 'grader_id'
  has_many :invites, foreign_key: 'grader_id'
  has_many :attended_cuppings, through: :invites, source: :cupping

  has_many :hosted_cuppings, foreign_key: 'host_id', class_name: 'Cupping'
end
