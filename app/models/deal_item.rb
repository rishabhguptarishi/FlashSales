class DealItem < ApplicationRecord
  belongs_to :deal
  #FIXME_AB: dependent restrict with error
  has_one :line_item

  #FIXME_AB: add required validations
  #FIXME_AB: add scopes
end
