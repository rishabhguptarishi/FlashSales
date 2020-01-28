class DealItem < ApplicationRecord

  STATUS = {
    available: 'available',
    booked: 'booked'
  }
  belongs_to :deal
  has_one :line_item, dependent: :restrict_with_error

  scope :available, -> { where(status: STATUS[:available]) }
  scope :booked, -> { where(status: STATUS[:booked]) }
end
