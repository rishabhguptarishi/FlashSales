# == Schema Information
#
# Table name: images
#
#  id             :bigint           not null, primary key
#  imageable_type :string(255)
#  imageable_id   :bigint
#

class Image < ApplicationRecord
  #FIXME_AB: we can make this polymorphic so that it can be used with deal and any other model
  belongs_to :imageable, polymorphic: true
  has_one_attached :image
end
