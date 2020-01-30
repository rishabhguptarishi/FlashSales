class ApiController < ApplicationController
  skip_before_action :authorize
  skip_before_action :set_order
  before_action :ensure_token_exists, :ensure_user_exists, only: [:myorders]

  def live_deals
    @deals = Deal.live
    render json: @deals, only: [:title, :price, :discounted_price, :quantity, :publish_at]
  end

  def past_deals
    @deals = Deal.past_deals.includes(:orders)
    render json: @deals, only: [:title, :price, :discounted_price, :quantity, :publish_at], include: [orders: {only: [:workflow_state, :order_paced_at]}]
  end

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
