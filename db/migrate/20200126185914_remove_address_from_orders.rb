class RemoveAddressFromOrders < ActiveRecord::Migration[6.0]
  def change
    change_table :orders do |t|
      t.remove :address
    end
  end
end
