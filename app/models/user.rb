require 'URI'
class User < ApplicationRecord
  belongs_to :role
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, confirmation: true, length: {within: 6..30}
  before_create -> { generate_token(:verification_token) }, unless: :is_admin?
  after_create_commit :send_verification_mail, unless: :is_admin?
  has_secure_password

  def activate_account
    self.verified = true
    self.verification_token = nil
    self.verification_token_generated_at = nil
    save!(validate: false)
  end

  def generate_token(column_name)
    if self[column_name].blank?
      self[column_name] = SecureRandom.urlsafe_base64.to_s
      self["#{column_name}_generated_at"] = Time.current
    end
  end

  def send_password_reset
    generate_token(:password_reset_token)
    save!(validate: false)
    UserMailer.password_reset(self).deliver_now
  end

  def is_admin?
    role.name == "admin"
  end

  private def send_verification_mail
    UserMailer.registration_confirmation(self).deliver_now
  end
end
