class ApplicationController < ActionController::Base
  before_action :authorize
  helper_method :current_user
  def current_user
    @current_user
  end

  private def authorize
    if cookies[:remember_me_token]
      @current_user = User.find_by(remember_me_token: cookies[:remember_me_token])
    else
      #FIXME_AB: you should fire this query if user_id is present in the session. Hence this 'else' shoudl be 'elseif'
      @current_user = User.find_by(id: session[:user_id])
    end
    unless @current_user
      redirect_to login_url, alert: "Please login"
    end
  end
end
