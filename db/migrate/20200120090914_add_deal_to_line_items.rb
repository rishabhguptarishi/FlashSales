class AddDealToLineItems < ActiveRecord::Migration[6.0]
  def change
    change_table :line_items do |t|
      t.references :deal, null: false
    end
  end
end
