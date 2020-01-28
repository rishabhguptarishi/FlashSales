# == Schema Information
#
# Table name: images
#
#  id             :bigint           not null, primary key
#  imageable_type :string(255)
#  imageable_id   :bigint
#

class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  has_one_attached :image

  def process_image
    if image.variable?
      image.attachment.variant(resize_to_limit: [ ENV['deal_image_height'].to_i, ENV['deal_image_width'].to_i ]).processed
    else
      image
    end
  end
end
