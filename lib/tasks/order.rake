namespace :order do
  desc "delete orders that have not been placed for more than 15 minutes"
  task delete_hanged_orders: :environment do
    orders = Order.where(created_at: 15.minutes.ago).where(workflow_state: 'new')
    orders.deal_items.update_all(status: 'available')
    orders.destroy_all
  end

end
