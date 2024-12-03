class ReviewBlueprinter < Blueprinter::Base
  identifier :id

  view :normal do
    fields :id, :email, :first_name, :last_name, :rating, :title, :description
  end

  view :admin_extended do
    include_view :normal
    fields :created_at, :updated_at
  end
end
