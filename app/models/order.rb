class Order < ApplicationRecord
  include WorkflowActiverecord
  workflow do
    state :new do
      event :checkout, transitions_to: :placed
    end

    state :placed do
      #FIXME_AB: just wondering why do we need to move placed order to new state. If we don't need then lets remove this
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
  #FIXME_AB: we should't not do dependent destroy with address, just nullify,
  has_one :address, dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :address, allow_destroy: true

  #FIXME_AB: should we use prepend true ? else line items will be deleted first and then we won't find deal_items through line_items
  before_destroy :destroy_order_associations

  #FIXME_AB: Lets discuss why do we need 'past' scope
  scope :past,      -> { where('order_placed_at <= ?', Time.current) }
  scope :placed,    -> { where(workflow_state: 'placed') }
  scope :delivered, -> { where(workflow_state: 'delivered') }
  scope :cancelled, -> { where(workflow_state: 'cancelled') }
  scope :cart,      -> { where(workflow_state: 'new') }

  #FIXME_AB: lets discuss this, we may not need this.
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
    #FIXME_AB: we should save the discounted price of item in the line_items table itself. other we ll need to recalculate this everytime and apply user's discount. And since user's eligible discount is variable, total will vary with time
    #FIXME_AB: if we do the above we can just use .sum method line_items.sum(&:discounted_price) or something similar
    line_items.each do |item|
      total_price += item.deal.discounted_price
    end
    total_price - (total_price * user.eligible_additional_discount/100)
    #FIXME_AB: Also I think we should calculate the total amount and save it with the order itself. That way can help if we ever run reports on orders table.
  end

  #FIXME_AB: Since this is a callback method, I think we should make it private
  def destroy_order_associations
    if current_state == 'new'
      release_blocked_deals
    else
      false
    end
  end
end
