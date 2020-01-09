class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.boolean :verified
      t.string :verification_token
      t.string :remember_me_token
      t.string :password_reset_token
      t.datetime :password_reset_send_at
      t.datetime :verification_send_at
      t.datetime :remember_me_set_at

      t.timestamps
    end
    add_index :users, :email
  end
end
