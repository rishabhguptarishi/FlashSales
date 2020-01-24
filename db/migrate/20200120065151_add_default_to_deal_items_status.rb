class AddDefaultToDealItemsStatus < ActiveRecord::Migration[6.0]
  def up
    change_column_default :deal_items, :status, 'available'
  end

  def down
    change_column_default :deal_items, :status, nil
  end
end
