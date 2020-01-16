# == Schema Information
#
# Table name: deals
#
#  id               :bigint           not null, primary key
#  title            :string(255)
#  description      :string(255)
#  price            :decimal(14, 2)
#  discounted_price :decimal(14, 2)
#  quantity         :integer
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
  validates :quantity, numericality: { only_integer: true}, if: -> { quantity.present? }
  validates_with DiscountPriceValidator
  validates_with PublishDateValidator

  #FIXME_AB: if a deal is published by cron, can not be marked as published

  #FIXME_AB: dependent option
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
    #FIXME_AB: Deal.find_by => self.class.find_by
    #FIXME_AB: use between
    Deals.find_by( publish_at: self.publish_at ).count < ENV['max_of_deals_for_a_day'].to_i
  end

end
