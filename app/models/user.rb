
class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> {email.present?}
  validates :password, presence: true
  validates :password, confirmation: true, length: {within: 6..30}, if: -> {password.present?}
  belongs_to :role
  before_create -> { generate_token(:verification_token) }, unless: :is_admin?
  after_create_commit :send_verification_mail, unless: :is_admin?
  scope :verified, -> { where(verified: true) }
  scope :customer, -> { where(role.name = 'customer') }
  scope :admin, -> { where(role.name = 'admin') }
  has_secure_password

  def activate_account
    self.verified = true
    self.verification_token = nil
    self.verification_token_generated_at = nil
    self.verified_at = Time.current
    save!(validate: false)
  end

  def generate_token(column_name)
    public_send("#{column_name}=", SecureRandom.urlsafe_base64.to_s)
    public_send("#{column_name}_generated_at=", Time.current)
  end

  def generate_token_bank(column_name)
    public_send("#{column_name}=", SecureRandom.urlsafe_base64.to_s)
    public_send("#{column_name}_generated_at=", Time.current)
    save!(validate: false)
  end

  def send_password_reset
    generate_token_bank(:password_reset_token)
    UserMailer.delay.password_reset(self)
  end

  def is_admin?
    role.name == "admin"
  end

  private def send_verification_mail
    UserMailer.delay.registration_confirmation(self)
  end
end
