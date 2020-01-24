class CreateDeals < ActiveRecord::Migration[6.0]
  def change
    create_table :deals do |t|
      t.string :title
      t.string :description
      t.decimal :price, precision: 14, scale: 2
      t.decimal :discounted_price, precision: 14, scale: 2
      t.integer :quantity
      t.datetime :publish_at
      t.boolean :publishable, default: false
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
