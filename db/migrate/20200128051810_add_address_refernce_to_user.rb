class AddAddressRefernceToUser < ActiveRecord::Migration[6.0]
  def change
    change_table :addresses, bulk: true do |t|
      t.remove_references :order
      t.references :user
    end
  end
end
