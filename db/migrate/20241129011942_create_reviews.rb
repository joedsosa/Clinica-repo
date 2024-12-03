class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.integer :rating
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
