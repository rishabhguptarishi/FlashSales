# == Schema Information
#
# Table name: addresses
#
#  id         :bigint           not null, primary key
#  state      :string(255)
#  city       :string(255)
#  country    :string(255)
#  pincode    :string(255)
#  line1      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#

class Address < ApplicationRecord
  include BasicPresenter::Concern
  validates :city, :country, :line1, :state, :pincode, presence: true

  belongs_to :user
  has_many :orders

  def full_address
    presenter.full_address
  end
end
