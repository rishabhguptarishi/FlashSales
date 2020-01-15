class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, confirmation: true, length: {within: 6..30}

  belongs_to :role
  before_create -> { generate_token(:verification_token) }, unless: :is_admin?
  after_create_commit :send_verification_mail, unless: :is_admin?

  scope :verified, -> { where(verified: true) }
  scope :publishable, -> { where(publishable: true) }
  scope :live_deals, -> { where(live: true) }
  scope :all_except, ->(user) { where.not(id: user.id) }

  has_secure_password

  #FIXME_AB: Since this method will save or raise exception, so name it as activate_account!
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

  def generate_token!(column_name)
    public_send("#{column_name}=", SecureRandom.urlsafe_base64.to_s)
    public_send("#{column_name}_generated_at=", Time.current)
    save!(validate: false)
  end

  def send_password_reset
    generate_token!(:password_reset_token)
    UserMailer.delay.password_reset(id)
  end

  def is_admin?
    role.name == "admin"
  end

  private def send_verification_mail
    UserMailer.delay.registration_confirmation(id)
  end
end
