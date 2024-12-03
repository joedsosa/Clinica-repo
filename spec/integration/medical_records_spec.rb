# spec/integration/medical_records_spec.rb
require 'swagger_helper'

TAGS_MEDICAL_RECORDS = 'Medical Records'.freeze

RSpec.describe 'api/v1/medical_records', type: :request do
  let(:user) { create(:user) }
  let!(:doctor) { create(:doctor) }
  let!(:patient) { create(:patient) }
  let!(:medical_records) { create_list(:medical_record, 5, doctor: doctor, patient: patient) }
  let(:medical_record_id) { medical_records.first.id }
  let(:headers) { user.create_new_auth_token.merge('Content-Type' => 'application/json') }

  include_context 'with auth tokens'

  path '/api/v1/medical_records' do
    # GET para obtener la lista de registros médicos
    get('list medical records') do
      tags TAGS_MEDICAL_RECORDS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page'
      parameter name: :doctor_id, in: :query, type: :integer, description: 'Filter by doctor\'s Id'
      parameter name: :patient_id, in: :query, type: :integer, description: 'Filter by patient\'s Id'

      response(200, 'successful', response_body_example: true) do
        let(:page) { 1 }
        let(:per_page) { 4 }
        let(:doctor_id) { '1' }
        let(:patient_id) { '1' }

        context 'with no filters' do
          schema '$ref' => '#/components/schemas/medical_records'

          run_test!
        end

        context 'with doctor_id filter' do
          before do
            get '/api/v1/medical_records', headers: headers, params: { doctor_id: medical_records.first.doctor_id }
          end
          run_test!
        end

        context 'with patient_id filter' do
          before do
            get '/api/v1/medical_records', headers: headers, params: { patient_id: medical_records.first.patient_id }
          end
          run_test!
        end
      end
    end

    # POST para crear un nuevo registro médico
    post('create medical record') do
      tags TAGS_MEDICAL_RECORDS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :medical_record, in: :body, schema: {
        type: :object,
        properties: {
          doctor_id: { type: :integer },
          patient_id: { type: :integer }
        },
        required: %w[doctor_id patient_id],
        example: {
          doctor_id: 1,
          patient_id: 1
        }
      }

      response(201, 'medical record created') do
        let(:medical_record) { { doctor_id: doctor.id, patient_id: patient.id } }

        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:medical_record) { { doctor_id: nil, patient_id: nil } }

        run_test!
      end
    end
  end

  path '/api/v1/medical_records/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Medical Record ID'

    # GET para obtener el registro médico por ID
    get('show medical record') do
      tags TAGS_MEDICAL_RECORDS
      include_context 'authentication parameter headers'
      produces 'application/json'

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/medical_record'
        let(:id) { medical_record_id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { '999' }
        run_test!
      end
    end

    # PUT para actualizar el registro médico
    put('update medical record') do
      tags TAGS_MEDICAL_RECORDS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      parameter name: :medical_record, in: :body, schema: {
        type: :object,
        properties: {
          doctor_id: { type: :integer }
        },
        example: {
          doctor_id: 1
        }
      }

      response(200, 'updated') do
        let(:id) { medical_record_id }
        let(:medical_record) { { doctor_id: doctor.id } }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { '999' }
        let(:medical_record) { {} }
        run_test!
      end
    end

    # DELETE para eliminar el registro médico
    delete('delete medical record') do
      tags TAGS_MEDICAL_RECORDS
      include_context 'authentication parameter headers'

      response(204, 'no content') do
        let(:id) { medical_record_id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { '999' }
        run_test!
      end
    end
  end
end
