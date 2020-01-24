class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :address
      t.references :user
      t.datetime :order_placed_at
      t.string :workflow_state
      t.integer :line_items_count

      t.timestamps
    end
  end
end
