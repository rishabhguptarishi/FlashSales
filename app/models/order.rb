class Order < ApplicationRecord
  include WorkflowActiverecord
  workflow do
    state :new do
      event :checkout, transitions_to: :placed
    end

    state :placed do
      event :cart, transitions_to: :new
      event :cancel, transitions_to: :cancelled
      event :deliver, transitions_to: :delivered
    end
    state :delivered
    state :cancelled
  end


  has_many :line_items, dependent: :destroy
  has_many :deal_items, through: :line_items
  belongs_to :user

  #FIXME_AB: you should have a before_destroy which should check whether order can be destroyed or not. if can be destroyed the it should mark deal_items available before destory

  scope :past_orders, -> { where('order_placed_at <= ?', Time.current) }
  scope :placed, -> { where(workflow_state: 'placed') }

  #FIXME_AB: review this function
  def self.search(search)
    if search
      user = User.find_by(emai: email)
      if user
        user.orders
      else
        Order.all
      end
    else
      Order.all
    end
  end

  #FIXME_AB: review this method for negative cases
  def add_line_item(deal_id)
    deal_item = Deal.find(deal_id).deal_items.where(status: 'available').first
    line_item = self.line_items.build
    line_item.deal_item = deal_item
    line_item.deal = deal_item.deal
    deal_item.update(status: 'booked')
  end

  def total_amount
    total_price = 0
    line_items.each do |item|
      total_price += item.deal.discounted_price
    end
    total_orders_till_date = user.orders.where.not(id: id).count
    #FIXME_AB: discount calculation should go in user. like user.eligible_additional_discount. Also consider just delivered orders
    discount = total_orders_till_date < 5 ? total_orders_till_date : 5
    final_amount = total_price - (total_price * discount/100)
  end
end
