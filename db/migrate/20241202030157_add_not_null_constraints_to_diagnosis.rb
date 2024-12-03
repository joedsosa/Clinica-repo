class AddNotNullConstraintsToDiagnosis < ActiveRecord::Migration[6.0]
  def change
    # Establece las columnas `doctor_id` y `patient_id` como `NOT NULL`
    change_column_null :diagnoses, :doctor_id, false
    change_column_null :diagnoses, :patient_id, false
  end
end
