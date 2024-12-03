class CreateDiagnoses < ActiveRecord::Migration[7.1]
  def change
    create_table :diagnoses do |t|
      t.integer :patient_id
      t.integer :doctor_id
      t.text :description

      t.timestamps
    end
  end
end
