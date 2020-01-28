module Admin
  class OrdersController < AdminController
    before_action :set_order, only: [:show, :delivered, :cancelled]

    def index
      @orders = Order.search(params[:search]).placed.page(params[:page])
    end

    def show
    end

    def mark_delivered!
      @order.deliver!
    end

    def mark_cancelled!
      @order.cancel!
    end

    private def set_order
      @order = Order.find(params[:id])
      unless @order
        redirect_to admin_orders_path, alert: 'This order doesnt exist'
      end
    end
  end
end
