class Role < ApplicationRecord

  ROLES = {
    admin:    'admin',
    customer: 'customer'
  }

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :users, dependent: :restrict_with_error

  scope :customer, -> { find_by(name: ROLES[:customer]) }
  scope :admin,    -> { find_by(name: ROLES[:admin]) }
end
