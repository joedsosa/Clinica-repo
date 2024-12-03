class CreateMedicalPrescriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :medical_prescriptions do |t|
      t.references :doctor, null: false, foreign_key: { to_table: :doctors }
      t.references :patient, null: false, foreign_key: { to_table: :patients }
      t.string :medication_name, null: false
      t.string :dosage, null: false
      t.string :frequency, null: false
      t.text :instructions
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
