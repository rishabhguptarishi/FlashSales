class ChargesController < ApplicationController
  before_action :set_order, only: [:create]


  def new
  end

  def create
    debugger
    customer = Stripe::Customer.create(
      email: current_user.email,
      source: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: (@order.total_amount * 100).to_i,
      description: 'Rails test payment',
      currency: 'usd'
    )
    session.delete(:order_id)
    @order.checkout!
    OrdersMailer.delay.placed(@order.id)

  rescue Stripe::CardError => e
    flash[:alert] = e.message
    @order.update(address: nil, order_placed_at: nil)
    redirect_to root_path
  end

  #FIXME_AB: same exists in applicatoin controller
  private def set_order
    if session[:order_id]
      @order = Order.find_by(id: session[:order_id])
    end
    unless @order
      @order = current_user.orders.new
    end
  end
end
