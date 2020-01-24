class ChangeDescriptionColumnType < ActiveRecord::Migration[6.0]
  def up
    change_column :deals, :description, :text
  end

  def down
    change_column :deals, :description, :string
  end
end
