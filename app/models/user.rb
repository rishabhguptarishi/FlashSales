# == Schema Information
#
# Table name: users
#
#  id                                :bigint           not null, primary key
#  name                              :string(255)
#  email                             :string(255)
#  password_digest                   :string(255)
#  verified                          :boolean          default(FALSE)
#  verification_token                :string(255)
#  remember_me_token                 :string(255)
#  password_reset_token              :string(255)
#  password_reset_token_generated_at :datetime
#  verification_token_generated_at   :datetime
#  remember_me_token_generated_at    :datetime
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  role_id                           :bigint           default(1), not null
#  verified_at                       :datetime
#

class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> {email.present?}
  validates :password, length: {within: 6..30}, if: -> {password.present?}

  belongs_to :role

  has_many :orders, dependent: :restrict_with_error
  has_many :line_items, through: :orders

  has_many :addresses

  with_options unless: :is_admin? do |user|
    before_create -> { generate_token(:verification_token) }
    after_create_commit :send_verification_mail
  end

  scope :verified,    -> { where(verified: true) }
  scope :publishable, -> { where(publishable: true) }
  scope :all_except,  -> (user) { where.not(id: user.id) }
  scope :top_spending_customers, -> { joins(:orders).group(:id).order('SUM(orders.total_price) desc') }

  has_secure_password

  def activate_account!
    self.verified = true
    self.verification_token = nil
    self.verification_token_generated_at = nil
    self.verified_at = Time.current
    generate_token(:authentication_token)
    save!(validate: false)
  end

  def update_user_password!
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    self.password_reset_token = nil
    self.password_reset_token_generated_at = nil
    generate_token(:authentication_token)
    save
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

  def already_bought?(deal_id)
    line_items.exists?(deal_id: deal_id)
  end

  def delete_cart
    orders.cart.destroy_all
  end

  def eligible_additional_discount
    total_delivered_orders = orders.delivered.count
    total_delivered_orders < 5 ? total_delivered_orders : 5
  end

  def is_admin?
    role.name == "admin"
  end

  private def send_verification_mail
    UserMailer.delay.registration_confirmation(id)
  end
end
