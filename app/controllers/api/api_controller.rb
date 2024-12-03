class Api::ApiController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  # Include all needed modules
  include Response
  include Pagination

  respond_to :json

  # Ensure all API actions require authentication
  before_action :authenticate_api_v1_user!, unless: :dont_authenticate, except: [:health_check]

  def health_check
    render json: { status: :ok }
  end

  def private_health_check
    render json: { status: :ok }
  end

  def dont_authenticate
    # Don't authenticate if the request is for the API documentation
    # Or if the request is for the sessions devise token auth controller
    api_docs_check || devise_controller?
  end

  private

  def sessions_controller?
    params[:controller] == 'api/v1/users/sessions' && params[:action] == 'create'
  end

  def api_docs_check
    request.referer.present? ? request.referer.include?('api-docs') : false
  end
end
