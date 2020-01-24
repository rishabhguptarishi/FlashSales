class DealItem < ApplicationRecord
  belongs_to :deal
  has_one :line_item
end
