class AddRememberMeToAdminUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :admin_users, :remember_me_token, :string, default: nil
    add_column :admin_users, :remember_me_token_expires_at, :datetime, default: nil
    add_index :admin_users, :remember_me_token
  end
end
