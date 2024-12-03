class MedicalPrescriptionBlueprinter < Blueprinter::Base
  identifier :id

  # Vista básica para casos generales
  view :normal do
    fields :id, :medication_name, :dosage, :frequency, :instructions, :start_date, :end_date, :doctor_id, :patient_id
  end

  # Vista extendida para administradores
  view :admin_extended do
    include_view :normal
    fields :created_at, :updated_at
    association :doctor, blueprint: DoctorBlueprinter, view: :normal
    association :patient, blueprint: PatientBlueprinter, view: :normal
  end

  # Vista pública (oculta información sensible)
  view :public do
    fields :medication_name, :dosage, :frequency, :instructions, :start_date, :end_date
  end
end
