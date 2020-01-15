class Role < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  validates :name, presence: true
  scope :customer, -> { find_by(name: 'customer') }
  scope :admin, -> { find_by(name: 'admin') }
end
