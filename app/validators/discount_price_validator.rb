class DiscountPriceValidator < ActiveModel::Validator
  def validate(record)
    if record.discounted_price.present? && record.price.present? && record.price < record.discounted_price
      record.errors[:discounted_price] << 'Discount price must be less than or equal to price'
    end
  end
end
