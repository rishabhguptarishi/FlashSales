class PasswordResetController < ApplicationController
  skip_before_action :authorize
  before_action :ensure_email_passed, only: [:create]
  before_action :ensure_token_exists, only: [:edit, :update]

  def create
    user = User.find_by(email: params[:email])
    if user
      user.send_password_reset
      redirect_to login_url, notice: "Email sent with password reset instructions."
    else
      flash.now[:alert] = "User not found"
      render :new
    end
  end

  def edit
    @user = User.find_by(password_reset_token: params[:token])
    if @user.blank?
      redirect_to login_path, alert: "Invalid link"
    elsif @user.password_reset_token_generated_at < ENV['password_reset_token_expiry_time_in_hours'].to_i.hours.ago
      @user.update(password_reset_token: nil, password_reset_token_generated_at: nil)
      redirect_to new_password_reset_path, alert: "Password reset link has expired."
    end
  end

  def update
    #FIXME_AB: following line is being repeated in edit and update actoins you can extract it in a before action 'load_user_by_reset_token'
    @user = User.find_by(password_reset_token: params[:token])
    if @user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation], password_reset_token: nil, password_reset_token_generated_at: nil)
      redirect_to login_url, notice: "Password has been reset!"
    else
      render :edit
    end
  end

  private def ensure_email_passed
    if params[:email].blank?
      flash.now[:alert] = "Please provide email id on which is registered with us"
      render :new
    end
  end

  private def ensure_token_exists
    if params[:token].blank?
      redirect_to login_url, alert: "Invalid token passed"
    end
  end
end
