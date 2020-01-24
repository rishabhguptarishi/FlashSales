module Admin
  class OrdersController < AdminController
    before_action :set_order, only: [:show, :delivered, :cancelled]

    def index
      @orders = Order.search(params[:search]).placed.page(params[:page])
    end

    def show
    end

    def delivered
      @order.deliver!
    end

    def cancelled
      @order.cancel!
      @order.deal_items.update_all(status: 'available')
    end

    private def set_order
      @order = Order.find(params[:id])
    end
  end
end
