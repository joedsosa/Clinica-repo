class CreateDoctors < ActiveRecord::Migration[7.1]
  def change
    create_table :doctors do |t|
      t.string :first_name
      t.string :last_name
      t.string :specialty
      t.time :start_working_at
      t.time :end_working_at
      t.timestamps
    end
  end
end
