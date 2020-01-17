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

  #FIXME_AB: add required validations on this model
end
