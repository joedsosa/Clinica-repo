module RailsAdminHelpersPatch
  extend ActiveSupport::Concern

  included do
    def logout_path
      Rails.application.routes.url_helpers.administrator_sign_out_administrators_sessions_path
    end

    def logout_method
      :delete
    end

    private

    def not_authenticated
      redirect_to '/administrators/sessions/new', alert: 'Please login first'
    end
  end
end
