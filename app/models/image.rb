# == Schema Information
#
# Table name: images
#
#  id      :bigint           not null, primary key
#  deal_id :bigint           not null
#

class Image < ApplicationRecord
  #FIXME_AB: we can make this polymorphic so that it can be used with deal and any other model
  belongs_to :imageable, polymorphic: true
  has_one_attached :image
end
