class Role < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  has_many :users, dependent: :restrict_with_error
  scope :customer, -> { find_by(name: 'customer') }
  scope :admin, -> { find_by(name: 'admin') }
end
