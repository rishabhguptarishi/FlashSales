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

  validates_associated :address

  has_many :line_items, dependent: :destroy
  has_many :deal_items, through: :line_items
  has_one :address, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :address, allow_destroy: true

  before_destroy :destroy_order_associations

  scope :past, -> { where('order_placed_at <= ?', Time.current) }
  scope :placed, -> { where(workflow_state: 'placed') }
  scope :delivered, -> { where(workflow_state: 'delivered') }
  scope :cancelled, -> { where(workflow_state: 'cancelled') }
  scope :cart, -> { where(workflow_state: 'new') }

  def self.search(search)
    if search
      user = User.find_by(email: search)
      if user
        user.orders
      else
        Order.all
      end
    else
      Order.all
    end
  end

  def cancel
    release_blocked_deals
  end

  def release_blocked_deals
    deal_items.update_all(status: 'available')
  end

  def add_line_item(deal_item)
    line_item = self.line_items.build
    line_item.deal_item = deal_item
    line_item.deal = deal_item.deal
  end

  def total_amount
    total_price = 0
    line_items.each do |item|
      total_price += item.deal.discounted_price
    end
    total_price - (total_price * user.eligible_additional_discount/100)
  end

  def destroy_order_associations
    if current_state == 'new'
      release_blocked_deals
    else
      false
    end
  end
end
