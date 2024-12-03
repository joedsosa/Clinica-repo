class AddDetailsToPatient < ActiveRecord::Migration[7.1]
  def change
    change_table :patients do |t|
      t.text :allergies
      t.text :current_medications
      t.string :emergency_contact_name
      t.string :emergency_contact_phone
      t.string :blood_type
    end
  end
end
