# spec/integration/patients_spec.rb
require 'swagger_helper'

TAGS_PATIENTS = 'Patients'.freeze

RSpec.describe 'api/v1/patients', type: :request do
  let!(:patients) { create_list(:patient, 10) }
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  valid_attributes = { first_name: 'John', last_name: 'Doe', blood_type: 'A+', emergency_contact_name: 'Jane Doe', emergency_contact_phone: '+50412345678' }

  include_context 'with auth tokens'

  path '/api/v1/patients' do
    get('list patients') do
      tags TAGS_PATIENTS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page'
      parameter name: :first_name, in: :query, type: :string, description: 'Filter by first name'
      parameter name: :last_name, in: :query, type: :string, description: 'Filter by patient\'s last name'

      response(200, 'successful', response_body_example: true) do
        let(:page) { 1 } # Define default value for page
        let(:per_page) { 5 } # Define default value for per_page
        let(:first_name) { 'John' } # Example filter for first name
        let(:last_name) { 'Cena' } # Example filter for first name

        context 'with no filters' do
          schema '$ref' => '#/components/schemas/patients'

          run_test!
        end

        context 'with first_name filter' do
          # schema '$ref' => '#/components/schemas/patients'
          before do
            get '/api/v1/patients', headers: headers, params: { first_name: patients.first.first_name }
          end
          run_test!
        end

        context 'with last_name filter' do
          # schema '$ref' => '#/components/schemas/patients'
          before do
            get '/api/v1/patients', headers: headers, params: { last_name: patients.first.last_name }
          end
          run_test!
        end
      end
    end

    post('create patient') do
      tags TAGS_PATIENTS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :patient, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string },
          blood_type: { type: :string },
          emergency_contact_name: { type: :string },
          emergency_contact_phone: { type: :string }
        },
        required: %w[first_name last_name blood_type emergency_contact_name emergency_contact_phone],
        example: {
          patient: {
            first_name: 'Alice',
            last_name: 'Smith',
            blood_type: 'O+',
            age: 25,
            birth_date: '1996-01-01',
            emergency_contact_name: 'Bob Smith',
            emergency_contact_phone: '+50412345678'
          }
        }
      }

      response(201, 'patient created', use_as_request_example: true, response_body_example: true) do
        let(:patient) { valid_attributes }

        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:patient) { { first_name: '', last_name: '', blood_type: '', emergency_contact_name: '', emergency_contact_phone: '' } }

        run_test!
      end
    end
  end

  path '/api/v1/patients/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Patient ID'

    get('show patient') do
      tags TAGS_PATIENTS
      include_context 'authentication parameter headers'
      produces 'application/json'

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/patient'
        let(:id) do
          Patient.create(first_name: 'John', last_name: 'Doe', current_medications: 'Iboprodol ultra', allergies: 'Denge', blood_type: 'A+', emergency_contact_name: 'Jane Doe',
                         emergency_contact_phone: '+50412345678').id
        end
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put('update patient') do
      tags TAGS_PATIENTS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      parameter name: :patient, in: :body, schema: {
        type: :object,
        properties: {
          patient: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string }
            }
          }
        },
        example: {
          patient: {
            first_name: 'Alice',
            last_name: 'Jones'
          }
        }
      }

      response(200, 'updated', use_as_request_example: true, response_body_example: true) do
        let(:id) { Patient.create(first_name: 'John', last_name: 'Doe', blood_type: 'A+', emergency_contact_name: 'Jane Doe', emergency_contact_phone: '+50412345678').id }
        let(:patient) { { first_name: 'Alice', last_name: 'Jones' } }
        run_test!
      end

      response(404, 'not found', use_as_request_example: true, response_body_example: true) do
        let(:id) { 'invalid' }
        let(:patient) { {} } # Minimal payload
        run_test!
      end
    end

    delete('delete patient') do
      tags TAGS_PATIENTS
      include_context 'authentication parameter headers'
      response(204, 'no content') do
        let(:id) { Patient.create(first_name: 'John', last_name: 'Doe', blood_type: 'A+', emergency_contact_name: 'Jane Doe', emergency_contact_phone: '+50412345678').id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
