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
  validates :title, presence: true, uniqueness: { case_sensitive: false}
  validates :description, presence: true
  validates :description_length, length: { minimum: 10, too_short: "is too short must be atleast %{count} words" }, if: -> {description.present?}
  validates :price, presence: true, numericality: { greater_than: 0}
  validates :discounted_price, presence: true, numericality: { greater_than_or_equal_to: 0}
  validates_with DiscountPriceValidator
  validates :publish_at, presence: true
  validates_with PublishDateValidator
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validates_with DealPublishedValidator

  has_many :images, as: :imageable, dependent: :destroy
  has_many :deal_items, dependent: :restrict_with_error
  has_many :line_items, dependent: :restrict_with_error
  has_many :orders, through: :line_items

  accepts_nested_attributes_for :images, allow_destroy: true

  after_save :set_publishabhle!

  scope :publishable, -> { where(publishable: true) }
  scope :live_deals, -> { where(live: true) }
  scope :scheduled_to_go_live_today, ->(current_time = Time.current) { where(publish_at: current_time.at_beginning_of_day..current_time.at_end_of_day) }
  scope :past_deals, -> { where('publish_at < ?', Time.current).order(publish_at: :desc) }

  def can_be_published?
    publishable || (has_minimum_images && has_minimum_quantity && max_deals_for_day_not_reached)
  end

  def set_publishabhle!
    update_column(:publishable, can_be_published?)
  end

  def cover_image
    cover_image = images[ENV['index_of_image_you_want_as_deal_cover'].to_i].image
    if cover_image.variable?
      cover_image.attachment.variant(resize_to_limit: [ ENV['deal_cover_image_height'].to_i, ENV['deal_cover_image_width'].to_i ]).processed
    else
      cover_image
    end
  end

  def create_deal_items
    #FIXME_AB: once deal is published or with in 24 hours, qty can not be changed
    #FIXME_AB: you need to adjust qtyis, they can increase or decrease. One way is to delete all deal_items and create fresh. if we do this we also need to make sure that no deal item is locked

    if quantity_changed?
      (quantity - deal_items.count).times do
        deal_items.build
      end
    end
  end

  def quantity_available?
    deal_items.exists?(status: 'available')
  end

  private def has_minimum_images
    images.count >= ENV['minimum_images_required_for_deals'].to_i
  end

  private def has_minimum_quantity
    quantity >= ENV['minimum_quantity_of_items_for_deal'].to_i
  end

  private def description_length
    description.strip.split(%r{\s})
  end

  def max_deals_for_day_not_reached
    self.class.where( publish_at: publish_at.at_beginning_of_day..publish_at.at_end_of_day ).where.not(id: id).count < ENV['max_of_deals_for_a_day'].to_i
  end

end
