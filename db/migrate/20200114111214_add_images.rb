class AddImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.references :deal, null: false
    end
  end
end
