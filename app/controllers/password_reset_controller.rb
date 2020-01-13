class PasswordResetController < ApplicationController
skip_before_action :authorize
  def create
    user = User.find_by(email: params[:email])
    if user
      user.send_password_reset
      redirect_to login_url, :notice => "Email sent with password reset instructions."
    else
      render :new, alert: "User not found"
    end
  end

  def edit
    @user = User.find_by(password_reset_token: params[:token])
    if @user.blank?
      redirect_to login_path, alert: "Invalid link"
    elsif @user.password_reset_token_generated_at < ENV['password_reset_token_expiry_time_in_hours'].to_i.hours.ago
      redirect_to new_password_reset_path, alert: "Password reset link has expired."
    end
  end

  def update
    @user = User.find_by(password_reset_token: params[:token])
    if @user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
      redirect_to login_url, notice: "Password has been reset!"
    else
      render :edit
    end
  end
end
