module Admin
  class OrdersController < AdminController
    before_action :set_order, only: [:mark_delivered!, :mark_cancelled!]

    def index
      @orders = Order.search(params[:search]).not_carts.page(params[:page])
    end

    def mark_delivered!
      @order.deliver!
      redirect_to admin_orders_path
    end

    def mark_cancelled!
      @order.cancel!
      redirect_to admin_orders_path
    end

    private def set_order
      @order = Order.find(params[:id])
      unless @order
        redirect_to admin_orders_path, alert: 'This order doesnt exist'
      end
    end
  end
end
