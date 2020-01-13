class Role < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  validates :name, presence: true
  #FIXME_AB: name should also be unique
end
