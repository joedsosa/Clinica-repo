class AddConstraintsToPatient < ActiveRecord::Migration[7.1]
  def change
    change_column_null :patients, :first_name, false
    change_column_null :patients, :last_name, false
  end
end
