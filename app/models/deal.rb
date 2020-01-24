# == Schema Information
#
# Table name: deals
#
#  id               :bigint           not null, primary key
#  title            :string(255)
#  description      :string(255)
#  price            :decimal(14, 2)   default(0.0)
#  discounted_price :decimal(14, 2)   default(0.0)
#  quantity         :integer          default(0)
#  publish_at       :datetime
#  publishable      :boolean          default(FALSE)
#  published        :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  live             :boolean          default(FALSE)
#

#FIXME_AB: set default values for price, discounted_price, quantity

class Deal < ApplicationRecord
  validates :title, :description, :price, :discounted_price, :quantity, :publish_at, presence: true
  validates :title, uniqueness: { case_sensitive: false}, if: -> { title.present? }
  validates :description, length: { maximum: 255 }, if: -> {:description.present?}
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0}, if: -> { quantity.present? }
  validates :price, numericality: { greater_than: 0}, if: -> { price.present? }
  validates :discounted_price, numericality: { greater_than_or_equal_to: 0}, if: -> { discounted_price.present? }
  validates_with DiscountPriceValidator
  validates_with PublishDateValidator
  validates_with DealPublishedValidator

  has_many :images, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :images, allow_destroy: true

  after_save :set_publishabhle!

  scope :publishable, -> { where(publishable: true) }
  scope :live_deals, -> { where(live: true) }
  #FIXME_AB: Time.current is call twice in this scope so you can do something like ->(current_time = Time.current) and use current_time inside the block
  scope :scheduled_to_go_live_today, -> { where(publish_at: Time.current.at_beginning_of_day..Time.current.at_end_of_day) }

  def can_be_published?
    publishable || (has_minimum_images && has_minimum_quantity && max_deals_for_day_not_reached)
  end

  def set_publishabhle!
    update_column(:publishable, can_be_published?)
  end

  def cover_image
    images[ENV['index_of_image_you_want_as_deal_cover'].to_i].image.attachment
  end


  private def has_minimum_images
    images.count >= ENV['minimum_images_required_for_deals'].to_i
  end

  private def has_minimum_quantity
    quantity >= ENV['minimum_quantity_of_items_for_deal'].to_i
  end

  private def max_deals_for_day_not_reached
    self.class.where( publish_at: publish_at.at_beginning_of_day..publish_at.at_end_of_day ).count < ENV['max_of_deals_for_a_day'].to_i
  end

end
