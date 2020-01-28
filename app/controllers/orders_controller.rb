class OrdersController < ApplicationController
  skip_before_action :set_order, only: [:past_orders]
  before_action :check_if_can_be_bought, only: [:add_line_item]
  before_action :ensure_cart_exist, only: [:checkout]
  before_action :set_order_address, only: [:place_order]
  after_action :set_order_session, only: [:add_line_item]

  def show
  end

  def add_line_item
    @order.add_line_item(@deal_item)
    if @order.save!
      redirect_to root_path, notice: 'order created'
    else
      redirect_to root_path, alert: 'could not create order try again'
    end
  end

  def checkout
    @order.build_address
  end

  def place_order
    total_amount = @order.total_amount
    respond_to do |format|
      if @order.update(order_placed_at: Time.current, total_price: total_amount)
        format.html { redirect_to new_charge_path }
      else
        format.html { render :checkout }
      end
    end
  end

  def past_orders
    @orders = current_user.orders.past.page(params[:page])
  end

  private def set_order_address
    if params[:order][:address].blank?
      @order.set_address(address_params, current_user)
    else
      @order.address = current_user.addresses.find(params[:order][:address])
    end
  end

  private def check_if_can_be_bought
    deal = Deal.live.find(params[:id])
    alert = get_alert(deal)
    if alert
      redirect_to root_path, alert: alert
    else
      @deal_item = deal.book!
    end
  end

  private def get_alert(deal)
    if !deal
      'Invalid Deal'
    elsif current_user.already_bought?(deal.id)
      'You already bought this deal'
    elsif !deal.quantity_available?
      'Sorry deal is sold out'
    end
  end

  private def ensure_cart_exist
    unless session[:order_id]
      redirect_to root_path, alert: 'Please add some items to order'
    end
  end

  private def set_order_session
    unless session[:order_id]
      session[:order_id] = @order.id
    end
  end

  private def address_params
    params.require(:order).require(:address_attributes).permit(:id, :city, :state, :country, :pincode, :line1)
  end
end
