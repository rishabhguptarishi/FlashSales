class QuantityValidator < ActiveModel::Validator
  def validate(record)
    if record.quantity_changed? && record.published
      record.errors[:quantity] << 'cannot be changed for already published deal'
    elsif record.quantity.present? && record.quantity_changed? && Time.current >= 24.hours.ago(record.publish_at)
      record.errors[:quantity] << 'cannot be changed for deals going live 24 hours from now'
    end
  end
end
