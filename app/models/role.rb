class Role < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  #FIXME_AB: instead of find by use where
  scope :customer, -> { find_by(name: 'customer') }
  scope :admin, -> { find_by(name: 'admin') }
end
