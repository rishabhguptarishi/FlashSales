class PasswordResetController < ApplicationController
  skip_before_action :authorize
  before_action :ensure_email_passed, only: [:create]
  before_action :ensure_token_exists, only: [:edit, :update]

  def create
    user = User.find_by(email: params[:email])
    if user
      user.send_password_reset
      redirect_to login_url, :notice => "Email sent with password reset instructions."
    else
      #FIXME_AB: fix alert
      render :new, alert: "User not found"
    end
  end

  def edit
    @user = User.find_by(password_reset_token: params[:token])
    if @user.blank?
      redirect_to login_path, alert: "Invalid link"
    elsif @user.password_reset_token_generated_at < ENV['password_reset_token_expiry_time_in_hours'].to_i.hours.ago
      #FIXME_AB: nil not null
      @user.update(password_reset_token: null, password_reset_token_generated_at: null)
      redirect_to new_password_reset_path, alert: "Password reset link has expired."
    end
  end

  #FIXME_AB: before action to ensure password_reset_token was present
  def update
    @user = User.find_by(password_reset_token: params[:token])
    #FIXME_AB: null or nil
    if @user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation], password_reset_token: null, password_reset_token_generated_at: null)
      redirect_to login_url, notice: "Password has been reset!"
    else
      render :edit
    end
  end

  private def ensure_email_passed
    if params[:email].blank?
      redirect_to new_password_reset_path, alert: "Please provide email id on which reset link will be sent"
    end
  end

  private def ensure_token_exists
    #FIXME_AB: check for blank/present
    unless params[:token]
      redirect_to login_url, alert: "Invalid token passed"
    end
  end
end
