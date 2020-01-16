class AddReferencesToImages < ActiveRecord::Migration[6.0]
  def change
    change_table :images, bulk: true do |t|
      t.remove :deal_id
      t.references :imageable, polymorphic: true
    end
  end
end
