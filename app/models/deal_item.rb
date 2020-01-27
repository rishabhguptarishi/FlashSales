class DealItem < ApplicationRecord
  belongs_to :deal
  has_one :line_item, dependent: :restrict_with_error

  scope :available, -> { where(status: 'available') }
end
