class AddVerifiedAtToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.datetime :verified_at
    end
  end
end
