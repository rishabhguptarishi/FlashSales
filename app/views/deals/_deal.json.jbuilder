json.extract! deal, :title, :price, :discounted_price, :quantity, :publish_at
json.array! deal.orders, partial: "orders/_order", as: :order
