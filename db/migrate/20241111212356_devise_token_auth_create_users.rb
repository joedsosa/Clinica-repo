class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[7.1]
  def change
    change_table :users do |t|
      ## Required
      t.string :provider, null: false, default: 'email'
      t.string :uid, null: false, default: ''

      t.boolean :allow_password_change, default: false

      ## User Info
      t.string :first_name
      t.string :last_name
      t.string :username

      ## Tokens
      t.json :tokens
    end

    add_index :users, [:uid, :provider], unique: true
  end
end
