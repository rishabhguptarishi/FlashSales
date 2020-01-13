class PasswordResetController < ApplicationController
  skip_before_action :authorize

  #FIXME_AB: before action to check that email was present
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
      redirect_to new_password_reset_path, alert: "Password reset link has expired."
    end
  end

  #FIXME_AB: before action to ensure password_reset_token was present
  def update
    @user = User.find_by(password_reset_token: params[:token])
    if @user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
      #FIXME_AB: you should also nullify password_reset_token.
      redirect_to login_url, notice: "Password has been reset!"
    else
      render :edit
    end
  end
end
