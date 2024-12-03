require 'rails_helper'

RSpec.describe 'MedicalPrescriptions API', type: :request do
  let(:user) { create(:user) }
  let!(:medical_prescriptions) { create_list(:medical_prescription, 5) }
  let(:medical_prescription_id) { medical_prescriptions.first.id }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  let(:valid_headers) do
    user.create_new_auth_token.merge('Content-Type' => 'application/json')
  end

  describe 'GET /api/v1/medical_prescriptions' do
    it 'returns a list of medical prescriptions with pagination' do
      get '/api/v1/medical_prescriptions', headers: valid_headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body).to have_key('data')
      expect(response_body['data'].size).to be <= 5
      expect(response_body).to have_key('meta')
      expect(response_body['meta']).to have_key('pagination')
    end
  end

  describe 'GET /api/v1/medical_prescriptions/:id' do
    context 'when the medical prescription exists' do
      it 'returns the medical prescription' do
        get "/api/v1/medical_prescriptions/#{medical_prescription_id}", headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('data')
        expect(response_body['data']['id']).to eq(medical_prescription_id)
      end
    end

    context 'when the medical prescription does not exist' do
      it 'returns a not found error' do
        get '/api/v1/medical_prescriptions/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v1/medical_prescriptions' do
    let(:valid_attributes) do
      {
        medical_prescription: {
          medication_name: 'Ibuprofen',
          dosage: '200mg',
          frequency: 'Twice a day',
          start_date: '2023-11-01',
          end_date: '2023-11-10',
          doctor_id: 1,
          patient_id: 1,
          instructions: 'Take with food'
        }
      }.to_json
    end

    let(:invalid_attributes) do
      {
        medical_prescription: {
          medication_name: '',
          dosage: '',
          frequency: '',
          start_date: '',
          end_date: '',
          doctor_id: nil,
          patient_id: nil
        }
      }.to_json
    end

    context 'when the request is valid' do
      it 'creates a new medical prescription' do
        post '/api/v1/medical_prescriptions', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:created)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('id')
        expect(response_body['medication_name']).to eq('Ibuprofen')
      end
    end

    context 'when the request is invalid' do
      it 'returns an unprocessable entity status' do
        post '/api/v1/medical_prescriptions', params: invalid_attributes, headers: valid_headers

        expect(response).to have_http_status(:unprocessable_entity)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('medication_name')
        expect(response_body['medication_name']).to include("can't be blank")
      end
    end
  end

  describe 'PUT /api/v1/medical_prescriptions/:id' do
    let(:valid_attributes) do
      {
        medical_prescription: {
          dosage: '400mg',
          frequency: 'Once a day'
        }
      }.to_json
    end

    context 'when the medical prescription exists' do
      it 'updates the medical prescription' do
        put "/api/v1/medical_prescriptions/#{medical_prescription_id}", params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['dosage']).to eq('400mg')
        expect(response_body['frequency']).to eq('Once a day')
      end
    end

    context 'when the medical prescription does not exist' do
      it 'returns a not found error' do
        put '/api/v1/medical_prescriptions/999', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /api/v1/medical_prescriptions/:id' do
    context 'when the medical prescription exists' do
      it 'deletes the medical prescription' do
        expect do
          delete "/api/v1/medical_prescriptions/#{medical_prescription_id}", headers: valid_headers
        end.to change { MedicalPrescription.count }.by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the medical prescription does not exist' do
      it 'returns a not found error' do
        delete '/api/v1/medical_prescriptions/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
