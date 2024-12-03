class SubscriptionBlueprinter < Blueprinter::Base
  identifier :id

  view :normal do
    fields :email, :first_name, :last_name, :terms_and_conditions
  end

  view :admin_extended do
    include_view :normal
    fields :created_at, :updated_at
  end
end
