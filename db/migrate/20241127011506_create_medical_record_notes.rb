class CreateMedicalRecordNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :medical_record_notes do |t|
      # Medical record note belongs to a doctor
      t.references :doctor, null: false, foreign_key: true

      # Medical record note has been done by an user
      t.references :user, null: false, foreign_key: true

      # Medical record note belongs to a medical record
      t.references :medical_record, null: false, foreign_key: true

      # Medical record note has a note field
      # that can contain up to 500 characters
      # and cannot be null
      t.text :description, null: false, limit: 500

      # Medical record note has a created_at and updated_at timestamp
      t.timestamps
    end
  end
end
