class Api::V1::Users::PasswordsController < DeviseTokenAuth::PasswordsController
  skip_before_action :authenticate_api_v1_user!

  private

  def redirect_options
    {
      allow_other_host: true
    }
  end
end
