class AddTotalPriceToOrders < ActiveRecord::Migration[6.0]
  def change
    change_table :orders do |t|
      t.integer :total_price, default: 0
    end
  end
end
