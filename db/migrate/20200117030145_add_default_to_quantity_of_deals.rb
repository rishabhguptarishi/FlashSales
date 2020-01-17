class AddDefaultToQuantityOfDeals < ActiveRecord::Migration[6.0]
  def up
    change_column_default :deals, :quantity, 0
  end

  def down
    change_column_default :deals, :quantity, nil
  end
end
