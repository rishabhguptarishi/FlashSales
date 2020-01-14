class AddLiveToDeals < ActiveRecord::Migration[6.0]
  def change
    change_table :deals do |t|
      t.boolean :live, default: false
    end
  end
end
