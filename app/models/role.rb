class Role < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  scope :customer, -> { find_by(name: 'customer') }
  scope :admin, -> { find_by(name: 'admin') }
  #FIXME_AB: name should also be unique
end
