module Api
  class DealsController < ApiController
    def live_deals
      @deals = Deal.live
      render json: @deals, only: [:title, :price, :discounted_price, :quantity, :publish_at]
    end

    def past_deals
      @deals = Deal.past_deals.includes(:orders)
      render json: @deals, only: [:title, :price, :discounted_price, :quantity, :publish_at], include: [orders: {only: [:workflow_state, :order_paced_at]}]
    end
  end
end
