class CreateMedicalRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :medical_records do |t|
      # Medical record belongs to a patient
      t.references :patient, null: false, foreign_key: true

      # Medical record needs to have the doctor who created it
      t.references :doctor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
