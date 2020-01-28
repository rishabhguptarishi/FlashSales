class LineItem < ApplicationRecord
  belongs_to :order, counter_cache: true
  belongs_to :deal_item
  belongs_to :deal

  def set_price
    price = deal.discounted_price
    self.price  = price - (price * order.user.eligible_additional_discount/100)
  end
end
