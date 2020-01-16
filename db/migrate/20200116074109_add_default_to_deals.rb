class AddDefaultToDeals < ActiveRecord::Migration[6.0]
  def change
    change_table :deals, bulk: true do |t|
      t.change_default :price, default: 0
      t.change_default :discounted_price, default: 0
    end
  end
end
