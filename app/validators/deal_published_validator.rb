class DealPublishedValidator < ActiveModel::Validator
  def validate(record)
    if record.published_changed? && record.published_in_database
      record.errors[:published] << 'This deal is already published so cant be unpublished'
    end
  end
end
