class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  # configured for devise :confirmable, add to devise modules when appropriate

  include DeviseTokenAuth::Concerns::User

  alias_attribute :nickname, :username

  validates_presence_of :username, :email, :name
  validates_uniqueness_of :email
  # validates_uniqueness_of :username, case_sensitive: false

  has_many :scores, foreign_key: 'grader_id'
  has_many :invites, foreign_key: 'grader_id'
  has_many :accepted_invites,
           -> { where status: 'accepted' },
           foreign_key: 'grader_id',
           class_name: 'Invite'

  has_many :attended_cuppings,
           -> { where('cup_date < ?', DateTime.now) },
           through: :accepted_invites,
           source: :cupping

  has_many :hosted_cuppings, foreign_key: 'host_id', class_name: 'Cupping'
end
