class OrdersController < ApplicationController
  skip_before_action :set_order, only: [:past_orders]
  before_action :check_if_can_be_bought, only: [:create, :update, :add_line_item]
  before_action :ensure_cart_exist, only: [:checkout]
  after_action :set_order_session, only: [:add_line_item]

  def show
  end

  def add_line_item
    @order.add_line_item(@deal_item)
    respond_to do |format|
      if @order.save
        format.html { redirect_to root_path, notice: 'order created' }
      else
        format.html { render :new }
      end
    end
  end

  def checkout
    @order.build_address
  end

  def place_order
    if params[:order][:address].blank?
      @order.build_address(address_params)
    else
      @order.address = Address.find(params[:order][:address]).dup
    end
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


  private def check_if_can_be_bought
    deal = Deal.find(params[:id])
    if !deal
      redirect_to root_path, alert: 'Invalid Deal'
    elsif current_user.already_bought?(deal)
      redirect_to root_path, alert: 'You already bought this deal'
    elsif deal.quantity_available?
      @deal_item = deal.book!
    else
      redirect_to root_path, alert: 'Sorry deal is sold out'
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
