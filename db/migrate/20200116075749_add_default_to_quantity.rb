class AddDefaultToQuantity < ActiveRecord::Migration[6.0]
  def change
    change_table :deals, bulk: true do |t|
      t.change_default :quantity, default: 0
    end
  end
end
