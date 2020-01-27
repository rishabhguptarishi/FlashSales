class DealItem < ApplicationRecord
  belongs_to :deal
  has_one :line_item, dependent: :restrict_with_error

  #FIXME_AB: add validation on deal status should be in predefined states

    scope :available, -> { where(status: 'available') }
    #FIXME_AB: create another scope for bloked
end
