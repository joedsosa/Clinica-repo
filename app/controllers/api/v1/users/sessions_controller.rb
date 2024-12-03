class Api::V1::Users::SessionsController < DeviseTokenAuth::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  # Skip authentication for login
  skip_before_action :authenticate_api_v1_user!, only: [:create]

  # Override the create action to add custom behavior if needed
  # def create
  #   super
  # end

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:session, keys: [:email, :password])
  end
end
