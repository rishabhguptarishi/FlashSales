class Address < ApplicationRecord
  validates :city, :country, :line1, :state, :pincode, presence: true

  belongs_to :order

  def full_address
    "#{line1} #{city} #{state} #{country} #{pincode}"
  end
end
