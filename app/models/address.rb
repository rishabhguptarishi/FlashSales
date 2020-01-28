class Address < ApplicationRecord
  include BasicPresenter::Concern
  validates :city, :country, :line1, :state, :pincode, presence: true

  belongs_to :user
  has_many :orders

  def full_address
    presenter.full_address
  end
end
