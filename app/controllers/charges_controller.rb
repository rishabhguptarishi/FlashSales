class ChargesController < ApplicationController
  rescue_from Stripe::CardError, with: :catch_exception
  before_action :ensure_cart_exist, only: [:new]
  after_action :order_placed, only: [:create]


  def new
  end

  def create
    if current_user.stripe_customer_id
      customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    end

    if customer
      customer = Stripe::Customer.update(
        customer.id,
        source: params[:stripeToken],
        address: {
          city: params[:stripeBillingAddressCity],
          country: params[:stripeBillingAddressCountryCode],
          line1: params[:stripeBillingAddressLine1],
          postal_code: params[:stripeBillingAddressZip],
          state: params[:stripeBillingAddressState]
        }
      )
    else
      customer = Stripe::Customer.create(
        email: current_user.email,
        source: params[:stripeToken],
        name: current_user.name,
        address: {
          city: params[:stripeBillingAddressCity],
          country: params[:stripeBillingAddressCountryCode],
          line1: params[:stripeBillingAddressLine1],
          postal_code: params[:stripeBillingAddressZip],
          state: params[:stripeBillingAddressState]
        }
      )
      current_user.update_attribute(:stripe_customer_id, customer.id)
    end


    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: (@order.total_amount * 100).to_i,
      description: @order.line_items.map(&:deal_id).join,
      currency: 'inr'
    )
    redirect_to root_path, notice: 'Order has been placed successfully'
  end

  private def catch_exception(exception)
    flash[:error] = exception.message
    @order.update(order_placed_at: nil)
    @order.address.destroy
    redirect_to root_path
  end

  private def order_placed
    session[:order_id] = nil
    @order.checkout!
    OrdersMailer.delay.placed(@order.id)
  end

  private def ensure_cart_exist
    unless session[:order_id]
      redirect_to root_path, alert: 'Please add some items to order'
    end
  end
end
