class AddOrderReferenceToAddress < ActiveRecord::Migration[6.0]
  def change
    change_table :orders do |t|
      t.references :address
    end
  end
end
