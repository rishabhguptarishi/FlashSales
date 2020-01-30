class AddAuthTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.string :authentication_token
      t.datetime :authentication_token_generated_at
    end
  end
end
