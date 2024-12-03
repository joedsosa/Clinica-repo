require 'rails_helper'

RSpec.describe 'Patients API', type: :request do
  let(:user) { create(:user) } # Assume authentication is required
  let!(:patients) { create_list(:patient, 5) }
  let(:patient_id) { patients.first.id }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  let(:valid_headers) do
    user.create_new_auth_token.merge('Content-Type' => 'application/json')
  end

  describe 'GET /api/v1/patients' do
    it 'returns a list of patients with pagination' do
      get '/api/v1/patients', headers: valid_headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body).to have_key('data')
      expect(response_body['data'].size).to be <= 5
      expect(response_body).to have_key('meta')
      expect(response_body['meta']).to have_key('pagination')
    end
  end

  # Filterable test
  # GET /api/v1/patients?first_name=John
  describe 'GET /api/v1/patients?first_name=John' do
    let!(:patient_name) { create(:patient, first_name: 'John') }

    it 'returns a list of patients with the first name John' do
      get '/api/v1/patients?first_name=John', headers: valid_headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body).to have_key('data')
      expect(response_body['data'].size).to be <= 2
      expect(response_body['data'].first['first_name']).to eq('John')
    end
  end

  # GET /api/v1/patients?last_name=Cena
  describe 'GET /api/v1/patients?last_name=Cena' do
    let!(:patient_last_name) { create(:patient, last_name: 'Cena') }

    it 'returns a list of patients with the last name Cena' do
      get '/api/v1/patients?last_name=Cena', headers: valid_headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body).to have_key('data')
      expect(response_body['data'].size).to be <= 2
      expect(response_body['data'].first['last_name']).to eq('Cena')
    end
  end

  describe 'GET /api/v1/patients/:id' do
    context 'when the patient exists' do
      it 'returns the patient' do
        get "/api/v1/patients/#{patient_id}", headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('data')
        expect(response_body['data']['id']).to eq(patient_id)
      end
    end

    context 'when the patient does not exist' do
      it 'returns a not found error' do
        get '/api/v1/patients/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v1/patients' do
    let(:valid_attributes) do
      {
        patient: {
          first_name: 'John',
          last_name: 'Cena',
          blood_type: 'A+',
          emergency_contact_name: 'Jane Doe',
          emergency_contact_phone: '+50422222222'
        }
      }.to_json
    end

    let(:invalid_attributes) do
      {
        patient: {
          first_name: '',
          last_name: '',
          blood_type: '',
          emergency_contact_name: '',
          emergency_contact_phone: ''
        }
      }.to_json
    end

    context 'when the request is valid' do
      it 'creates a new patient' do
        post '/api/v1/patients', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:created)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('id')
        expect(response_body['first_name']).to eq('John')
      end
    end

    context 'when the request is invalid' do
      it 'returns an unprocessable entity status' do
        post '/api/v1/patients', params: invalid_attributes, headers: valid_headers

        expect(response).to have_http_status(:unprocessable_entity)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('first_name')
        expect(response_body['first_name']).to include("can't be blank")
      end
    end
  end

  describe 'PUT /api/v1/patients/:id' do
    let(:valid_attributes) do
      {
        patient: {
          first_name: 'Jane',
          last_name: 'Smith'
        }
      }.to_json
    end

    context 'when the patient exists' do
      it 'updates the patient' do
        put "/api/v1/patients/#{patient_id}", params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['first_name']).to eq('Jane')
        expect(response_body['last_name']).to eq('Smith')
      end
    end

    context 'when the patient does not exist' do
      it 'returns a not found error' do
        put '/api/v1/patients/999', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /api/v1/patients/:id' do
    context 'when the patient exists' do
      it 'deletes the patient' do
        expect do
          delete "/api/v1/patients/#{patient_id}", headers: valid_headers
        end.to change { Patient.count }.by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the patient does not exist' do
      it 'returns a not found error' do
        delete '/api/v1/patients/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
