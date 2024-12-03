class DoctorBlueprinter < Blueprinter::Base
  identifier :id

  view :normal do
    fields :first_name, :last_name, :specialty, :start_working_at, :end_working_at
  end

  view :admin_extended do
    include_view :normal
    fields :created_at, :updated_at
  end
end
