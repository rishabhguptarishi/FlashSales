class PublishDateValidator < ActiveModel::Validator
  def validate(record)
    if record.publish_at_changed? && record.published
      record.errors[:publish_at] << 'Publish date cannot be changed for already published deal'
    elsif record.publish_at.present? && record.publish_at_changed? && Time.current >= 24.hours.ago(record.publish_at)
      record.errors[:publish_at] << 'Publish date must be ahead by 24 hours from now'
    end
  end
end
