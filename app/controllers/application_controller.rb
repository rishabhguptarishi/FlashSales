class ApplicationController < ActionController::Base
  before_action :authorize, :set_layout
  helper_method :current_user

  def current_user
    @current_user
  end

  private def authorize
    if cookies[:remember_me_token]
      @current_user = User.find_by(remember_me_token: cookies.signed[:remember_me_token])
    elsif session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    end
    unless @current_user
      redirect_to login_url, alert: "Please login"
    end
  end

  private def set_layout
    if @current_user.is_admin?
      self.class.layout 'admin'
    end
  end
end
