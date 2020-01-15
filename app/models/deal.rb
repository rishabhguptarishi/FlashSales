class Deal < ApplicationRecord
  validates :title, :description, :price, :discounted_price, :quantity, :publish_at, presence: true
  validates :title, uniqueness: { case_sensitive: false}, if: -> { title.present? }
  validates :quantity, numericality: { only_integer: true}, if: -> { quantity.present? }
  validates_with DiscountPriceValidator
  validates_with PublishDateValidator
  has_many :images
  accepts_nested_attributes_for :images, allow_destroy: true
  scope :publishable, -> { where(publishable: true) }
  scope :live_deals, -> { where(live: true) }

  def can_be_published?
    publishable || (has_minimum_images && has_minimum_quantity && max_deals_for_day_not_reached)
  end

  private def has_minimum_images
    images.count >= ENV['minimum_images_required_for_deals'].to_i
  end

  private def has_minimum_quantity
    quantity >= ENV['minimum_quantity_of_items_for_deal'].to_i
  end

  private def max_deals_for_day_not_reached
    Deals.find_by( publish_at: self.publish_at ).count < ENV['max_of_deals_for_a_day'].to_i
  end

end
