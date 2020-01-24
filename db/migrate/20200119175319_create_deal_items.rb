class CreateDealItems < ActiveRecord::Migration[6.0]
  def change
    create_table :deal_items do |t|
      t.references :deal, null: false
      t.string :status
      t.timestamps
    end
  end
end
