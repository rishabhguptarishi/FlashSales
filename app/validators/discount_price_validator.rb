class DiscountPriceValidator < ActiveModel::Validator
  def validate(record)
    if record.discounted_price.present? && record.price.present? && record.price <= record.discounted_price
      record.errors[:discounted_price] << 'must be less than price'
    end
  end
end
