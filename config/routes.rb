Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :administrators do
    resources :sessions, only: [:new, :create] do
      delete :sign_out, on: :collection, as: :administrator_sign_out
    end
    resources :registrations, only: [:new, :create]
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # Authentication endpoints
      mount_devise_token_auth_for 'User', at: 'auth', contrllers: {
        sessions: 'api/v1/users/sessions',
        passwords: 'api/v1/users/passwords'
      }

      # Protected resources
      resources :doctors, :patients, :medical_records, :reviews, :subscriptions, :medical_record_notes, :medicines, :diagnoses, :medical_prescriptions
    end
  end

  # Letter opener
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
