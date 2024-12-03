class MedicineBlueprinter < Blueprinter::Base
  identifier :id
  view :normal do
    fields :name, :description, :dosage, :dosage_form, :instructions
  end
  view :admin_extended do
    include_view :normal
    fields :created_at, :updated_at
  end
end
