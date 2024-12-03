class PatientBlueprinter < Blueprinter::Base
  identifier :id

  view :normal do
    fields :first_name, :last_name, :allergies, :current_medications,
           :emergency_contact_name, :emergency_contact_phone, :blood_type
  end

  view :admin_extended do
    include_view :normal
    fields :created_at, :updated_at
  end
end
