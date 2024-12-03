require 'rails_helper'

RSpec.describe 'Medicines API', type: :request do
  let(:user) { create(:user) }
  let!(:medicines) { create_list(:medicine, 5) }
  let(:medicine_id) { medicines.first.id }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  let(:valid_headers) do
    user.create_new_auth_token.merge('Content-Type' => 'application/json')
  end

  describe 'GET /api/v1/medicines' do
    it 'returns a list of medicines' do
      get '/api/v1/medicines', headers: valid_headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body).to have_key('data')
      expect(response_body['data'].size).to be <= 5
    end
  end

  describe 'GET /api/v1/medicines/:id' do
    context 'when the medicine exists' do
      it 'returns the medicine' do
        get "/api/v1/medicines/#{medicine_id}", headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('data')
        expect(response_body['data']['id']).to eq(medicine_id)
      end
    end

    context 'when the medicine does not exist' do
      it 'returns a not found error' do
        get '/api/v1/medicines/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v1/medicines' do
    let(:valid_attributes) do
      {
        medicine: {
          name: 'Paracetamol',
          description: 'Pain relief',
          dosage: '500mg',
          dosage_form: 'Tablet',
          instructions: 'Take one tablet every 6 hours'
        }
      }.to_json
    end

    let(:invalid_attributes) do
      {
        medicine: {
          name: '',
          description: '',
          dosage: '',
          dosage_form: '',
          instructions: ''
        }
      }.to_json
    end

    context 'when the request is valid' do
      it 'creates a new medicine' do
        post '/api/v1/medicines', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:created)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('id')
        expect(response_body['name']).to eq('Paracetamol')
      end
    end

    context 'when the request is invalid' do
      it 'returns an unprocessable entity status' do
        post '/api/v1/medicines', params: invalid_attributes, headers: valid_headers

        expect(response).to have_http_status(:unprocessable_entity)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('name')
        expect(response_body['name']).to include("can't be blank")
      end
    end
  end

  describe 'PUT /api/v1/medicines/:id' do
    let(:valid_attributes) do
      {
        medicine: {
          name: 'Ibuprofen',
          description: 'Anti-inflammatory',
          dosage: '200mg',
          dosage_form: 'Tablet',
          instructions: 'Take one tablet every 8 hours'
        }
      }.to_json
    end

    context 'when the medicine exists' do
      it 'updates the medicine' do
        put "/api/v1/medicines/#{medicine_id}", params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['name']).to eq('Ibuprofen')
      end
    end

    context 'when the medicine does not exist' do
      it 'returns a not found error' do
        put '/api/v1/medicines/999', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /api/v1/medicines/:id' do
    context 'when the medicine exists' do
      it 'deletes the medicine' do
        expect do
          delete "/api/v1/medicines/#{medicine_id}", headers: valid_headers
        end.to change { Medicine.count }.by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the medicine does not exist' do
      it 'returns a not found error' do
        delete '/api/v1/medicines/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
