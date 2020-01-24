class OrdersController < ApplicationController
  skip_before_action :set_order, only: [:past_orders]
  before_action :check_if_already_bought, only: [:create, :update]
  before_action :validate_address_present, only: [:place_order]

  def show
  end

  def create
    @order.add_line_item(params[:deal])
    respond_to do |format|
      if @order.save
        session[:order_id] = @order.id
        format.html { redirect_to root_path, notice: 'order created' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @order.add_line_item(params[:id])
    respond_to do |format|
      if @order.save
        format.html { redirect_to root_path, notice: 'order updated' }
      else
        format.html { render :new }
      end
    end
  end

  def checkout
  end

  def place_order
    respond_to do |format|
      if @order.update(address: params[:address], order_placed_at: Time.current)
        format.html { redirect_to new_charge_path }
      else
        format.html { render :new }
      end
    end
  end

  def past_orders
    @orders = current_user.orders.past_orders.page(params[:page])
  end


  private def check_if_already_bought
    if current_user.line_items.exists?(deal_id: params[:id])
      redirect_to root_path, alert: 'You already bought this deal'
    end
  end

  private def validate_address_present
    if params[:order][:address].blank?
      flash[:alert] = 'Please provide address'
      render 'checkout'
    end
  end
end
