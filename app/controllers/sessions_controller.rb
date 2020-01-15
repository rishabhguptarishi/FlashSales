class SessionsController < ApplicationController
  skip_before_action :authorize

  def new
  end

  def create
    user = User.verified.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if params[:remember_me] && user.generate_token!(:remember_me_token)
        #FIXME_AB: sensitive info in cookie, cookie should be signed cookie
        cookies.signed.permanent[:remember_me_token] = user.remember_me_token
      end
      redirect_to user_path, notice: 'Successfully logged in!'
    else
      redirect_to login_url, alert: 'Invalid email/password combination and please make sure your account is verified'
    end
  end

  def destroy
    reset_session
    #FIXME_AB: you should extract the following code to delete cookies in loop in a private method
    delete_stored_cookies
    #FIXME_AB: read about the difference between render and redirect
    render login_url, notice: "Logged Out"
  end

  private def delete_stored_cookies
    YAML.load(ENV['cookies_to_be_deleted_on_logout']).each do |cookie|
      cookies.delete(cookie)
    end
  end
end
