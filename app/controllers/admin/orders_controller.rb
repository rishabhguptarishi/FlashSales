module Admin
  class OrdersController < AdminController
    before_action :set_order, only: [:show, :delivered, :cancelled]

    def index
      @orders = Order.search(params[:search]).placed.page(params[:page])
    end

    def show
    end

    def mark_delivered!
      #FIXME_AB: we also need to notify user, use workflow callback
      @order.deliver!
    end

    def mark_cancelled!
      #FIXME_AB: we also need to notify user, use workflow callback
      @order.cancel!
    end

    private def set_order
      @order = Order.find(params[:id])
      unless @order
        #FIXME_AB: redirec to orders page
        redirect_to admin_deals_path, alert: 'This order doesnt exist'
      end
    end
  end
end
