module Api
  class OrdersController < ApiController
    before_action :ensure_token_exists, :ensure_user_exists, only: [:myorders]

    def myorders
      @orders = @user.orders
      render json: @orders
    end

    private def ensure_token_exists
      if params[:token].blank?
        redirect_to root_path, alert: "Invalid token passed"
      end
    end

    private def ensure_user_exists
      @user = User.find_by(authentication_token: params[:token])
      if user.blank?
        redirect_to root_path, alert: "Invalid token passed"
      end
    end
  end
end
