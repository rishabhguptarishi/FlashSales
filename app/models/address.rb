class Address < ApplicationRecord
  validates :city, :country, :line1, :state, :pincode, presence: true

  #FIXME_AB: Address should also belongs to user.
  belongs_to :order
end
