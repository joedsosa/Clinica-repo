class DiagnosisBlueprinter < Blueprinter::Base
  identifier :id

  view :normal do
    fields :doctor_id, :patient_id, :description
  end

  view :admin_extended do
    include_view :normal
    fields :created_at, :updated_at
  end
end
