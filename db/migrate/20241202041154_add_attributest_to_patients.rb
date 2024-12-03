class AddAttributestToPatients < ActiveRecord::Migration[7.1]
  def change
    # Add birth date and age
    add_column :patients, :birth_date, :date
    add_column :patients, :age, :integer
  end
end
