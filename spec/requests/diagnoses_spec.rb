require 'rails_helper'

RSpec.describe 'Diagnoses API', type: :request do
  let(:user) { create(:user) }
  let!(:doctor) { create(:doctor) }
  let!(:patient) { create(:patient) }
  let!(:diagnoses) { create_list(:diagnosis, 5, doctor: doctor, patient: patient) }
  let(:diagnosis_id) { diagnoses.first.id }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  let(:valid_headers) do
    user.create_new_auth_token.merge('Content-Type' => 'application/json')
  end

  describe 'GET /api/v1/diagnoses' do
    it 'returns a list of diagnoses with pagination' do
      get '/api/v1/diagnoses', headers: valid_headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body).to have_key('data')
      expect(response_body['data'].size).to be <= 5
      expect(response_body).to have_key('meta')
      expect(response_body['meta']).to have_key('pagination')
    end
  end

  describe 'GET /api/v1/diagnoses/:id' do
    context 'when the diagnosis exists' do
      it 'returns the diagnosis' do
        get "/api/v1/diagnoses/#{diagnosis_id}", headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('data')
        expect(response_body['data']['id']).to eq(diagnosis_id)
      end
    end

    context 'when the diagnosis does not exist' do
      it 'returns a not found error' do
        get '/api/v1/diagnoses/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v1/diagnoses' do
    let(:valid_attributes) do
      {
        diagnosis: {
          description: 'Flu-like symptoms',
          doctor_id: doctor.id,
          patient_id: patient.id
        }
      }.to_json
    end

    let(:invalid_attributes) do
      {
        diagnosis: {
          description: '',
          doctor_id: nil,
          patient_id: nil
        }
      }.to_json
    end

    context 'when the request is valid' do
      it 'creates a new diagnosis' do
        post '/api/v1/diagnoses', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:created)
        response_body = JSON.parse(response.body)
        expect(response_body['description']).to eq('Flu-like symptoms')
        expect(response_body['doctor_id']).to eq(doctor.id)
      end
    end

    context 'when the request is invalid' do
      it 'returns an unprocessable entity status' do
        post '/api/v1/diagnoses', params: invalid_attributes, headers: valid_headers

        expect(response).to have_http_status(:unprocessable_entity)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('description')
      end
    end
  end

  describe 'PUT /api/v1/diagnoses/:id' do
    let(:valid_attributes) do
      {
        diagnosis: {
          description: 'Updated diagnosis description'
        }
      }.to_json
    end

    context 'when the diagnosis exists' do
      it 'updates the diagnosis' do
        put "/api/v1/diagnoses/#{diagnosis_id}", params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['description']).to eq('Updated diagnosis description')
      end
    end

    context 'when the diagnosis does not exist' do
      it 'returns a not found error' do
        put '/api/v1/diagnoses/999', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /api/v1/diagnoses/:id' do
    context 'when the diagnosis exists' do
      it 'deletes the diagnosis' do
        expect do
          delete "/api/v1/diagnoses/#{diagnosis_id}", headers: valid_headers
        end.to change(Diagnosis, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the diagnosis does not exist' do
      it 'returns a not found error' do
        delete '/api/v1/diagnoses/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
