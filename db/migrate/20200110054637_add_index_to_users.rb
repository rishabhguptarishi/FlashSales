class AddIndexToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users, bulk: true do |t|
      t.index :password_reset_token, unique: true
      t.index :verification_token, unique: true
      t.index :remember_me_token, unique: true
    end
  end
end
