class MedicalRecordNoteBlueprinter < Blueprinter::Base
  identifier :id
  view :normal do
    fields :description, :doctor_id, :medical_record_id, :user_id
  end
  view :admin_extended do
    include_view :normal
    fields :created_at, :updated_at
  end
end
