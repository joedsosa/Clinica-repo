require 'rails_helper'

RSpec.describe 'MedicalRecords API', type: :request do
  let(:user) { create(:user) }
  let!(:doctor) { create(:doctor) }
  let!(:patient) { create(:patient) }
  let!(:medical_records) { create_list(:medical_record, 5, doctor: doctor, patient: patient) }
  let(:medical_record_id) { medical_records.first.id }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  let(:valid_headers) do
    user.create_new_auth_token.merge('Content-Type' => 'application/json')
  end

  describe 'GET /api/v1/medical_records' do
    it 'returns a list of medical records with pagination' do
      get '/api/v1/medical_records', headers: valid_headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body).to have_key('data')
      expect(response_body['data'].size).to be <= 5
      expect(response_body).to have_key('meta')
      expect(response_body['meta']).to have_key('pagination')
    end
  end

  describe 'GET /api/v1/medical_records/:id' do
    context 'when the medical record exists' do
      it 'returns the medical record' do
        get "/api/v1/medical_records/#{medical_record_id}", headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('data')
        expect(response_body['data']['id']).to eq(medical_record_id)
      end
    end

    context 'when the medical record does not exist' do
      it 'returns a not found error' do
        get '/api/v1/medical_records/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v1/medical_records' do
    let(:valid_attributes) do
      {
        medical_record: {
          doctor_id: doctor.id,
          patient_id: patient.id
        }
      }.to_json
    end

    let(:invalid_attributes) do
      {
        medical_record: {
          doctor_id: nil,
          patient_id: nil
        }
      }.to_json
    end

    context 'when the request is valid' do
      it 'creates a new medical record' do
        post '/api/v1/medical_records', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:created)
        response_body = JSON.parse(response.body)
        expect(response_body['doctor_id']).to eq(doctor.id)
      end
    end

    context 'when the request is invalid' do
      it 'returns an unprocessable entity status' do
        post '/api/v1/medical_records', params: invalid_attributes, headers: valid_headers

        expect(response).to have_http_status(:unprocessable_entity)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('doctor')
      end
    end
  end

  describe 'PUT /api/v1/medical_records/:id' do
    let(:valid_attributes) do
      {
        medical_record: {
          doctor_id: doctor.id
        }
      }.to_json
    end

    context 'when the medical record exists' do
      it 'updates the medical record' do
        put "/api/v1/medical_records/#{medical_record_id}", params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['doctor_id']).to eq(doctor.id)
      end
    end

    context 'when the medical record does not exist' do
      it 'returns a not found error' do
        put '/api/v1/medical_records/999', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /api/v1/medical_records/:id' do
    context 'when the medical record exists' do
      it 'deletes the medical record' do
        expect do
          delete "/api/v1/medical_records/#{medical_record_id}", headers: valid_headers
        end.to change(MedicalRecord, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the medical record does not exist' do
      it 'returns a not found error' do
        delete '/api/v1/medical_records/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
