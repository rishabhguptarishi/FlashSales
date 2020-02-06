# == Schema Information
#
# Table name: line_items
#
#  id           :bigint           not null, primary key
#  order_id     :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  deal_item_id :bigint           not null
#  deal_id      :bigint           not null
#  price        :decimal(14, 2)
#

class LineItem < ApplicationRecord
  belongs_to :order, counter_cache: true
  belongs_to :deal_item
  belongs_to :deal

  def set_price
    price = deal.discounted_price
    self.price  = price - (price * order.user.eligible_additional_discount/100)
  end
end
