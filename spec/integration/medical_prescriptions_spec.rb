# spec/integration/medical_prescriptions_spec.rb
require 'swagger_helper'

TAGS_MEDICAL_PRESCRIPTIONS = 'Medical Prescriptions'.freeze

RSpec.describe 'api/v1/medical_prescriptions', type: :request do
  let(:doctor) { create(:doctor) }
  let(:patient) { create(:patient) }
  let!(:medical_prescriptions) { create_list(:medical_prescription, 5) }
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let(:valid_attributes) do
    {
      medical_prescription: {
        medication_name: 'Ibuprofen',
        dosage: '200mg',
        frequency: 'Twice a day',
        start_date: '2023-11-01',
        end_date: '2023-11-10',
        doctor_id: doctor.id,
        patient_id: patient.id,
        instructions: 'Take with food'
      }
    }
  end

  include_context 'with auth tokens'

  path '/api/v1/medical_prescriptions' do
    get('list medical prescriptions') do
      tags TAGS_MEDICAL_PRESCRIPTIONS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page'

      response(200, 'successful', response_body_example: true) do
        let(:page) { 1 }
        let(:per_page) { 5 }

        context 'with no filters' do
          schema type: :object,
                 properties: {
                   data: {
                     type: :array,
                     items: {
                       type: :object,
                       properties: {
                         id: { type: :integer },
                         medication_name: { type: :string },
                         dosage: { type: :string },
                         instructions: { type: :string },
                         patient_id: { type: :integer },
                         doctor_id: { type: :integer },
                         start_date: { type: :string, format: 'date' },
                         end_date: { type: :string, format: 'date' }
                       }
                     }
                   }
                 }
          run_test!
        end
      end
    end

    post('create medical prescription') do
      tags TAGS_MEDICAL_PRESCRIPTIONS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :medical_prescription, in: :body, schema: {
        type: :object,
        properties: {
          medication_name: { type: :string },
          dosage: { type: :string },
          instructions: { type: :string },
          patient_id: { type: :integer }
        },
        required: %w[medication_name dosage instructions patient_id],
        example: {
          medical_prescription: {
            medication_name: 'Ibuprofen',
            dosage: '200mg',
            instructions: 'Take one tablet after meals',
            patient_id: 1
          }
        }
      }

      response(201, 'medical prescription created', use_as_request_example: true, response_body_example: true) do
        let(:medical_prescription) { valid_attributes }
        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:medical_prescription) { { medication_name: '', dosage: '', instructions: '', patient_id: nil } }
        run_test!
      end
    end
  end

  path '/api/v1/medical_prescriptions/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Medical Prescription ID'

    get('show medical prescription') do
      tags TAGS_MEDICAL_PRESCRIPTIONS
      include_context 'authentication parameter headers'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     medication_name: { type: :string },
                     dosage: { type: :string },
                     instructions: { type: :string },
                     patient_id: { type: :integer },
                     doctor_id: { type: :integer },
                     start_date: { type: :string, format: 'date' },
                     end_date: { type: :string, format: 'date' }
                   }
                 }
               }
        let(:id) { medical_prescriptions.first.id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put('update medical prescription') do
      tags TAGS_MEDICAL_PRESCRIPTIONS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      parameter name: :medical_prescription, in: :body, schema: {
        type: :object,
        properties: {
          medical_prescription: {
            type: :object,
            properties: {
              medication_name: { type: :string },
              dosage: { type: :string },
              instructions: { type: :string }
            }
          }
        },
        example: {
          medical_prescription: {
            medication_name: 'Paracetamol',
            dosage: '500mg',
            instructions: 'Take two tablets daily'
          }
        }
      }

      response(200, 'updated', use_as_request_example: true, response_body_example: true) do
        let(:id) { medical_prescriptions.first.id }
        let(:medical_prescription) { { medication_name: 'Paracetamol', dosage: '500mg', instructions: 'Take two tablets daily' } }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        let(:medical_prescription) { {} }
        run_test!
      end
    end

    delete('delete medical prescription') do
      tags TAGS_MEDICAL_PRESCRIPTIONS
      include_context 'authentication parameter headers'

      response(204, 'no content') do
        let(:id) { medical_prescriptions.first.id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
