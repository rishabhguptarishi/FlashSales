module Admin
  class OrdersController < AdminController
    before_action :set_order, only: [:show, :delivered, :cancelled]

    def index
      @orders = Order.search(params[:search]).placed.page(params[:page])
    end

    def show
    end

    #FIXME_AB: rename to mark_delivered!
    def delivered
      @order.deliver!
    end

    #FIXME_AB: mark_cancelled
    def cancelled
      @order.cancel!
      #FIXME_AB: this shoudl be done by ca callback to the event and have a method for this @order.release_blocked_deal which should do the job.
      @order.deal_items.update_all(status: 'available')
    end

    private def set_order
      #FIXME_AB: what if record not found
      @order = Order.find(params[:id])
    end
  end
end
