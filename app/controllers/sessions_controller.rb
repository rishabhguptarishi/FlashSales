class SessionsController < ApplicationController
  skip_before_action :authorize, :set_layout

  def new
  end

  def create
    user = User.verified.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if params[:remember_me] && user.generate_token_bank(:remember_me_token)
        cookies.signed.permanent[:remember_me_token] = user.remember_me_token
      end
      redirect_to user_path(user.id), notice: 'Successfully logged in!'
    else
      redirect_to login_url, alert: 'Invalid email/password combination and please make sure your account is verified'
    end
  end

  def destroy
    reset_session
    YAML.load(ENV['cookies_to_be_deleted_on_logout']).each do |cookie|
      cookies.delete(cookie)
    end
    redirect_to login_url, notice: "Logged Out"
  end
end
