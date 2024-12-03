class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  # RailsAdmin support
  include AbstractController::Helpers
  include ActionController::Flash
  include ActionController::RequestForgeryProtection
  include ActionController::MimeResponds
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionView::Layouts

  RailsAdmin::ApplicationHelper.include RailsAdminHelpersPatch
end
