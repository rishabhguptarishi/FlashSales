class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password]) && user.verified
      session[:user_id] = user.id
      if params[:remember_me]
        user.generate_token(:remember_me_token)
        user.save!
        cookies.permanent[:auth_token] = user.remember_me_token
      end
      redirect_to login_url, alert: 'Successfully logged in!'
    else
      redirect_to login_url, alert: 'Invalid email/password combination and please make sure your account is verified'
    end
  end

  def destroy
    reset_session
    cookies.delete(:remember_me_token)
    redirect_to login_url, notice: "Logged Out"
  end
end
