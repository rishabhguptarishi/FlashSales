class OrdersController < ApplicationController
  skip_before_action :set_order, only: [:past_orders]
  before_action :check_if_already_bought, only: [:create, :update]
  before_action :validate_address_present, only: [:place_order]

  def show
  end

  #FIXME_AB: instead of create and update actions, make add_item.
  # Add item action will have  before actions.
  #1. check if item has bought already
  #2. ensure order exists(this will load order form session or create a new order and save in session)
  #3. ensure that deal is available for purchase, qty available and live

  # def add_item
  #   @order.add_line_item(@deal)
  # end

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
      #FIXME_AB: extract address in a new model user has many address, address belongs to user. order belongs to address.
      if @order.update(address: params[:address], order_placed_at: Time.current)
        format.html { redirect_to new_charge_path }
      else
        format.html { render :new }
      end
    end
  end

  def past_orders
    #FIXME_AB: current_user.orders.past
    @orders = current_user.orders.past_orders.page(params[:page])
  end


  private def check_if_already_bought
    #FIXME_AB: this logic shoudl be in user: current_user.can_by?(params[:deal_id])
    if current_user.line_items.exists?(deal_id: params[:id])
      redirect_to root_path, alert: 'You already bought this deal'
    end
  end

  #FIXME_AB: since we'll move address to other model, so Address class should have validations
  private def validate_address_present
    if params[:order][:address].blank?
      flash[:alert] = 'Please provide address'
      render 'checkout'
    end
  end
end
