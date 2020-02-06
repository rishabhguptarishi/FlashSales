# == Schema Information
#
# Table name: deal_items
#
#  id         :bigint           not null, primary key
#  deal_id    :bigint           not null
#  status     :string(255)      default("available")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
