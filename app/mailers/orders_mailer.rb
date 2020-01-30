class OrdersMailer < ApplicationMailer
  default from: ENV['default_mailers_from']

  def placed(order_id)
    @order = Order.placed.find(order_id)
    if @order
      mail(to: "#{@order.user.name} <#{@order.user.email}>", subject: "Order Placed")
    end
  end

  def delivered(order_id)
    @order = Order.delivered.find(order_id)
    if @order
      mail(to: "#{@order.user.name} <#{@order.user.email}>", subject: "Order Delivered")
    end
  end

  def cancelled(order_id)
    @order = Order.cancelled.find(order_id)
    if @order
      mail(to: "#{@order.user.name} <#{@order.user.email}>", subject: "Order cancelled")
    end
  end
end
