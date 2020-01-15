class PasswordResetController < ApplicationController
  skip_before_action :authorize
  before_action :ensure_email_passed, only: [:create]
  before_action :ensure_token_exists, only: [:edit, :update]

  #FIXME_AB: before action to check that email was present in the request params
  def create
    user = User.find_by(email: params[:email])
    if user
      user.send_password_reset
      redirect_to login_url, :notice => "Email sent with password reset instructions."
    else
      render :new, alert: "User not found"
    end
  end

  #FIXME_AB: before action to ensure password_reset_token was present
  def edit
    @user = User.find_by(password_reset_token: params[:token])
    if @user.blank?
      redirect_to login_path, alert: "Invalid link"
    elsif @user.password_reset_token_generated_at < ENV['password_reset_token_expiry_time_in_hours'].to_i.hours.ago
      #FIXME_AB: you should also nullify password_reset_token.
      @user.update(password_reset_token: null, password_reset_token_generated_at: null)
      redirect_to new_password_reset_path, alert: "Password reset link has expired."
    end
  end

  #FIXME_AB: before action to ensure password_reset_token was present
  def update
    @user = User.find_by(password_reset_token: params[:token])
    if @user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation], password_reset_token: null, password_reset_token_generated_at: null)
      #FIXME_AB: you should also nullify password_reset_token.
      redirect_to login_url, notice: "Password has been reset!"
    else
      render :edit
    end
  end

  private def ensure_email_passed
    unless params[:email]
      render new, alert: "Please provide email id on which reset link will be sent"
    end
  end

  private def ensure_token_exists
    unless params[:token]
      redirect_to login_url, alert: "Invalid token passed"
    end
  end
end
