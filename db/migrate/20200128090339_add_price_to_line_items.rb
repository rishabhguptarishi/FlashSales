class AddPriceToLineItems < ActiveRecord::Migration[6.0]
  def change
    change_table :line_items do |t|
      t.decimal :price, precision: 14, scale: 2
    end
  end
end
