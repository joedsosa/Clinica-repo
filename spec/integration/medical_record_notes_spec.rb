# spec/integration/medical_record_notes_spec.rb
require 'rails_helper'

RSpec.describe 'MedicalRecordNotes API', type: :request do
  let(:user) { create(:user) }
  let!(:doctor) { create(:doctor) } # Ensure this is inside the scope
  let!(:medical_record) { create(:medical_record) }
  let!(:medical_record_notes) { create_list(:medical_record_note, 5, doctor: doctor, medical_record: medical_record, user: user) }
  let!(:medical_record_note_id) { medical_record_notes.first.id }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  let(:valid_headers) do
    user.create_new_auth_token.merge('Content-Type' => 'application/json')
  end

  describe 'GET /api/v1/medical_record_notes' do
    it 'returns a list of medical record notes with pagination' do
      get '/api/v1/medical_record_notes', headers: valid_headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body).to have_key('data')
      expect(response_body['data'].size).to be <= 5
      expect(response_body).to have_key('meta')
      expect(response_body['meta']).to have_key('pagination')
    end
  end

  describe 'GET /api/v1/medical_record_notes/:id' do
    context 'when the medical record note exists' do
      it 'returns the medical record note' do
        get "/api/v1/medical_record_notes/#{medical_record_note_id}", headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('data')
        expect(response_body['data']['id']).to eq(medical_record_note_id)
      end
    end

    context 'when the medical record note does not exist' do
      it 'returns a not found error' do
        get '/api/v1/medical_record_notes/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v1/medical_record_notes' do
    let(:valid_attributes) do
      {
        medical_record_note: {
          doctor_id: doctor.id, # Ensure doctor is available here
          medical_record_id: medical_record.id,
          user_id: user.id,
          description: 'This is a valid note'
        }
      }.to_json
    end

    let(:invalid_attributes) do
      {
        medical_record_note: {
          doctor_id: nil,
          medical_record_id: nil,
          user_id: nil,
          description: nil
        }
      }.to_json
    end

    context 'when the request is valid' do
      it 'creates a new medical record note' do
        post '/api/v1/medical_record_notes', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:created)
        response_body = JSON.parse(response.body)
        expect(response_body['doctor_id']).to eq(doctor.id)
      end
    end

    context 'when the request is invalid' do
      it 'returns an unprocessable entity status' do
        post '/api/v1/medical_record_notes', params: invalid_attributes, headers: valid_headers

        expect(response).to have_http_status(:unprocessable_entity)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('doctor')
      end
    end
  end

  describe 'PUT /api/v1/medical_record_notes/:id' do
    let(:valid_attributes) do
      {
        medical_record_note: {
          description: 'Updated description'
        }
      }.to_json
    end

    context 'when the medical record note exists' do
      it 'updates the medical record note' do
        put "/api/v1/medical_record_notes/#{medical_record_note_id}", params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['description']).to eq('Updated description')
      end
    end

    context 'when the medical record note does not exist' do
      it 'returns a not found error' do
        put '/api/v1/medical_record_notes/999', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /api/v1/medical_record_notes/:id' do
    context 'when the medical record note exists' do
      it 'deletes the medical record note' do
        expect do
          delete "/api/v1/medical_record_notes/#{medical_record_note_id}", headers: valid_headers
        end.to change(MedicalRecordNote, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the medical record note does not exist' do
      it 'returns a not found error' do
        delete '/api/v1/medical_record_notes/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
