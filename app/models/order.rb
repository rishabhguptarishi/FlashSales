# == Schema Information
#
# Table name: orders
#
#  id               :bigint           not null, primary key
#  user_id          :bigint
#  order_placed_at  :datetime
#  workflow_state   :string(255)
#  line_items_count :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  total_price      :integer          default(0)
#  address_id       :bigint
#

class Order < ApplicationRecord
  include WorkflowActiverecord
  workflow do
    state :new do
      event :checkout, transitions_to: :placed
    end

    state :placed do
      event :cancel, transitions_to: :cancelled
      event :deliver, transitions_to: :delivered
    end
    state :delivered
    state :cancelled
  end

  has_many :line_items, dependent: :destroy
  has_many :deal_items, through: :line_items
  belongs_to :address, required: false
  belongs_to :user
  accepts_nested_attributes_for :address

  before_destroy :destroy_order_associations, prepend: true

  #FIXME_AB: Lets discuss why do we need 'past' scope
  scope :past,      -> { where('order_placed_at <= ?', Time.current) }
  scope :placed,    -> { where(workflow_state: 'placed') }
  scope :delivered, -> { where(workflow_state: 'delivered') }
  scope :cancelled, -> { where(workflow_state: 'cancelled') }
  scope :cart,      -> { where(workflow_state: 'new') }
  scope :not_carts, -> { where.not(workflow_state: 'new') }

  #FIXME_AB: lets discuss this, we may not need this.
  def self.search(search)
    if search
      User.find_by(email: search).try(:orders)
    else
      #FIXME_AB: should be paginated
      Order.all
    end
  end

  def deliver
    OrdersMailer.delay.delivered(id)
  end

  def cancel
    release_blocked_deals
    OrdersMailer.delay.cancelled(id)
  end

  def release_blocked_deals
    deal_items.update_all(status: 'available')
  end

  def set_address(address_params, current_user)
    build_address(address_params)
    address.user = current_user
  end

  def add_line_item(deal_item)
    line_item = self.line_items.build
    line_item.deal_item = deal_item
    line_item.deal = deal_item.deal
    line_item.set_price
  end

  def total_amount
    line_items.sum(&:price)
  end

  private def destroy_order_associations
    if current_state == 'new'
      release_blocked_deals
    else
      false
    end
  end
end
