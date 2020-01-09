class ChangeUsersColumnNames < ActiveRecord::Migration[6.0]
  def change
    change_table :users, bulk: true do |t|
      t.rename :password_reset_send_at, :password_reset_token_generated_at
      t.rename :verification_send_at, :verification_token_generated_at
      t.rename :remember_me_set_at, :remember_me_token_generated_at
    end
  end
end
