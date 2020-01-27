class Address < ApplicationRecord
  validates :city, :country, :line1, :state, :pincode, presence: true

  #FIXME_AB: Address should also belongs to user.
  belongs_to :order

  #FIXME_AB: Lets include basic_presenter gem and move this full_address to a presenter
  def full_address
    "#{line1} #{city} #{state} #{country} #{pincode}"
  end
end
