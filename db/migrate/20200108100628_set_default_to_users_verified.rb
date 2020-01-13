class SetDefaultToUsersVerified < ActiveRecord::Migration[6.0]
  def up
    change_column_default :users, :verified, false
  end

  def down
    change_column_default :users, :verified, nil
  end
end
