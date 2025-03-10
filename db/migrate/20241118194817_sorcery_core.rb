class SorceryCore < ActiveRecord::Migration[7.1]
  def change
    create_table :admin_users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :crypted_password
      t.string :salt

      t.timestamps null: false
    end
  end
end
