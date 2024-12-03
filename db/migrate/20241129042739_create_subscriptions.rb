class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.boolean :terms_and_conditions, null: false, default: false

      t.timestamps
    end

    add_index :subscriptions, :email, unique: true
  end
end
