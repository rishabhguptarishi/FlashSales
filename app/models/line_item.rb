class LineItem < ApplicationRecord
  belongs_to :order, counter_cache: true
  belongs_to :deal_item
  belongs_to :deal
end
