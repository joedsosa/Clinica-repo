require 'rails_helper'

RSpec.describe 'Doctors API', type: :request do
  let(:user) { create(:user) }

  # Create some sample doctors for testing
  let!(:doctors) { create_list(:doctor, 5) }
  let(:doctor_id) { doctors.first.id }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  let(:valid_headers) do
    user.create_new_auth_token.merge('Content-Type' => 'application/json')
  end

  describe 'GET /api/v1/doctors' do
    it 'returns a list of doctors with pagination' do
      get '/api/v1/doctors', headers: valid_headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body).to have_key('data')
      expect(response_body['data'].size).to be <= 5
      expect(response_body).to have_key('meta')
      expect(response_body['meta']).to have_key('pagination')
    end
  end

  describe 'GET /api/v1/doctors/:id' do
    context 'when the doctor exists' do
      it 'returns the doctor' do
        get "/api/v1/doctors/#{doctor_id}", headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('data')
        expect(response_body['data']['id']).to eq(doctor_id)
      end
    end

    context 'when the doctor does not exist' do
      it 'returns a not found error' do
        get '/api/v1/doctors/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v1/doctors' do
    let(:valid_attributes) do
      {
        doctor: {
          first_name: 'John',
          last_name: 'Doee',
          specialty: 'Cardiology',
          start_working_at: '08:00',
          end_working_at: '17:00'
        }
      }.to_json
    end

    let(:invalid_attributes) do
      {
        doctor: {
          first_name: '',
          last_name: '',
          specialty: '',
          start_working_at: nil,
          end_working_at: nil
        }
      }.to_json
    end

    context 'when the request is valid' do
      it 'creates a new doctor' do
        post '/api/v1/doctors', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:created)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('id')
        expect(response_body['first_name']).to eq('John')
      end
    end

    context 'when the request is invalid' do
      it 'returns an unprocessable entity status' do
        post '/api/v1/doctors', params: invalid_attributes, headers: valid_headers

        expect(response).to have_http_status(:unprocessable_entity)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('first_name')
        expect(response_body['first_name']).to include("can't be blank")
      end
    end
  end

  describe 'PUT /api/v1/doctors/:id' do
    let(:valid_attributes) do
      {
        doctor: {
          first_name: 'Jane',
          last_name: 'Smith'
        }
      }.to_json
    end

    context 'when the doctor exists' do
      it 'updates the doctor' do
        put "/api/v1/doctors/#{doctor_id}", params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['first_name']).to eq('Jane')
        expect(response_body['last_name']).to eq('Smith')
      end
    end

    context 'when the doctor does not exist' do
      it 'returns a not found error' do
        put '/api/v1/doctors/999', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /api/v1/doctors/:id' do
    context 'when the doctor exists' do
      it 'deletes the doctor' do
        expect do
          delete "/api/v1/doctors/#{doctor_id}", headers: valid_headers
        end.to change { Doctor.count }.by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the doctor does not exist' do
      it 'returns a not found error' do
        delete '/api/v1/doctors/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

# require 'rails_helper'

# RSpec.describe 'MedicalRecords API', type: :request do
#   let(:user) { create(:user) }
#   let(:doctor) { create(:doctor) }
#   let(:patient) { create(:patient) }
#   let!(:medical_records) { create_list(:medical_record, 5, doctor: doctor, patient: patient) }
#   let(:medical_record_id) { medical_records.first.id }
#   let(:headers) { { 'Content-Type' => 'application/json' } }

#   let(:valid_headers) do
#     user.create_new_auth_token.merge('Content-Type' => 'application/json')
#   end

#   describe 'GET /api/v1/medical_records' do
#     it 'returns a list of medical records with pagination' do
#       get '/api/v1/medical_records', headers: valid_headers

#       expect(response).to have_http_status(:ok)
#       response_body = JSON.parse(response.body)
#       expect(response_body).to have_key('data')
#       expect(response_body['data'].size).to be <= 5
#       expect(response_body).to have_key('meta')
#       expect(response_body['meta']).to have_key('pagination')
#     end
#   end

#   describe 'GET /api/v1/medical_records/:id' do
#     context 'when the medical record exists' do
#       it 'returns the medical record' do
#         get "/api/v1/medical_records/#{medical_record_id}", headers: valid_headers

#         expect(response).to have_http_status(:ok)
#         response_body = JSON.parse(response.body)
#         expect(response_body).to have_key('data')
#         expect(response_body['data']['id']).to eq(medical_record_id)
#       end
#     end

#     context 'when the medical record does not exist' do
#       it 'returns a not found error' do
#         get '/api/v1/medical_records/999', headers: valid_headers

#         expect(response).to have_http_status(:not_found)
#       end
#     end
#   end

#   describe 'POST /api/v1/medical_records' do
#     let(:valid_attributes) do
#       {
#         medical_record: {
#           doctor_id: doctor.id,
#           patient_id: patient.id,
#           notes: 'Patient is in good health.'
#         }
#       }.to_json
#     end

#     let(:invalid_attributes) do
#       {
#         medical_record: {
#           doctor_id: nil,
#           patient_id: nil,
#           notes: ''
#         }
#       }.to_json
#     end

#     context 'when the request is valid' do
#       it 'creates a new medical record' do
#         post '/api/v1/medical_records', params: valid_attributes, headers: valid_headers

#         expect(response).to have_http_status(:created)
#         response_body = JSON.parse(response.body)
#         expect(response_body).to have_key('data')
#         expect(response_body['data']['notes']).to eq('Patient is in good health.')
#       end
#     end

#     context 'when the request is invalid' do
#       it 'returns an unprocessable entity status' do
#         post '/api/v1/medical_records', params: invalid_attributes, headers: valid_headers

#         expect(response).to have_http_status(:unprocessable_entity)
#         response_body = JSON.parse(response.body)
#         expect(response_body).to have_key('errors')
#         expect(response_body['errors']).to include("Doctor must exist")
#         expect(response_body['errors']).to include("Patient must exist")
#       end
#     end
#   end

#   describe 'PUT /api/v1/medical_records/:id' do
#     let(:valid_attributes) do
#       {
#         medical_record: {
#           notes: 'Updated notes for medical record.'
#         }
#       }.to_json
#     end

#     context 'when the medical record exists' do
#       it 'updates the medical record' do
#         put "/api/v1/medical_records/#{medical_record_id}", params: valid_attributes, headers: valid_headers

#         expect(response).to have_http_status(:ok)
#         response_body = JSON.parse(response.body)
#         expect(response_body['data']['notes']).to eq('Updated notes for medical record.')
#       end
#     end

#     context 'when the medical record does not exist' do
#       it 'returns a not found error' do
#         put '/api/v1/medical_records/999', params: valid_attributes, headers: valid_headers

#         expect(response).to have_http_status(:not_found)
#       end
#     end
#   end

#   describe 'DELETE /api/v1/medical_records/:id' do
#     context 'when the medical record exists' do
#       it 'deletes the medical record' do
#         expect do
#           delete "/api/v1/medical_records/#{medical_record_id}", headers: valid_headers
#         end.to change { MedicalRecord.count }.by(-1)

#         expect(response).to have_http_status(:no_content)
#       end
#     end

#     context 'when the medical record does not exist' do
#       it 'returns a not found error' do
#         delete '/api/v1/medical_records/999', headers: valid_headers

#         expect(response).to have_http_status(:not_found)
#       end
#     end
#   end
# end
