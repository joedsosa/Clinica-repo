require 'rails_helper'

RSpec.describe 'Subscriptions API', type: :request do
  let(:user) { create(:user) }
  let!(:subscriptions) { create_list(:subscription, 5) }
  let(:subscription_id) { subscriptions.first.id }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  let(:valid_headers) do
    user.create_new_auth_token.merge('Content-Type' => 'application/json')
  end

  describe 'GET /api/v1/subscriptions' do
    it 'returns a list of subscriptions with pagination' do
      get '/api/v1/subscriptions', headers: valid_headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body).to have_key('data')
      expect(response_body['data'].size).to be <= 5
      expect(response_body).to have_key('meta')
      expect(response_body['meta']).to have_key('pagination')
    end
  end

  describe 'GET /api/v1/subscriptions?email=test@example.com' do
    let!(:subscription_with_email) { create(:subscription, email: 'test@example.com') }

    it 'returns subscriptions filtered by email' do
      get '/api/v1/subscriptions?email=test@example.com', headers: valid_headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body).to have_key('data')
      expect(response_body['data'].all? { |s| s['email'] == 'test@example.com' }).to eq(true)
    end
  end

  describe 'GET /api/v1/subscriptions/:id' do
    context 'when the subscription exists' do
      it 'returns the subscription' do
        get "/api/v1/subscriptions/#{subscription_id}", headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('data')
        expect(response_body['data']['id']).to eq(subscription_id)
      end
    end

    context 'when the subscription does not exist' do
      it 'returns a not found error' do
        get '/api/v1/subscriptions/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v1/subscriptions' do
    let(:valid_attributes) do
      {
        subscription: {
          email: 'test@example.com',
          first_name: 'John',
          last_name: 'Doe',
          terms_and_conditions: true
        }
      }.to_json
    end

    let(:invalid_attributes) do
      {
        subscription: {
          email: '',
          first_name: '',
          last_name: '',
          terms_and_conditions: false
        }
      }.to_json
    end

    context 'when the request is valid' do
      it 'creates a new subscription' do
        post '/api/v1/subscriptions', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:created)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('id')
        expect(response_body['email']).to eq('test@example.com')
      end
    end

    context 'when the request is invalid' do
      it 'returns an unprocessable entity status' do
        post '/api/v1/subscriptions', params: invalid_attributes, headers: valid_headers

        expect(response).to have_http_status(:unprocessable_entity)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('email')
        expect(response_body['email']).to include("can't be blank")
      end
    end
  end

  describe 'PUT /api/v1/subscriptions/:id' do
    let(:valid_attributes) do
      {
        subscription: {
          first_name: 'Jane',
          last_name: 'Smith',
          terms_and_conditions: true
        }
      }.to_json
    end

    context 'when the subscription exists' do
      it 'updates the subscription' do
        put "/api/v1/subscriptions/#{subscription_id}", params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['first_name']).to eq('Jane')
        expect(response_body['last_name']).to eq('Smith')
        expect(response_body['terms_and_conditions']).to eq(true)
      end
    end

    context 'when the subscription does not exist' do
      it 'returns a not found error' do
        put '/api/v1/subscriptions/999', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /api/v1/subscriptions/:id' do
    context 'when the subscription exists' do
      it 'deletes the subscription' do
        expect do
          delete "/api/v1/subscriptions/#{subscription_id}", headers: valid_headers
        end.to change { Subscription.count }.by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the subscription does not exist' do
      it 'returns a not found error' do
        delete '/api/v1/subscriptions/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
