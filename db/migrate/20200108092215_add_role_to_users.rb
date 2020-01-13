class AddRoleToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :role, default: 1, null: false
  end
end
