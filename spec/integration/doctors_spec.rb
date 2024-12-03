# spec/integration/doctors_spec.rb
require 'swagger_helper'

TAGS_DOCTORS = 'Doctors'.freeze

RSpec.describe 'api/v1/doctors', type: :request do
  let!(:doctors) { create_list(:doctor, 10) }
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  valid_attributes = { first_name: 'John', last_name: 'Doe', specialty: 'Cardiology', start_working_at: '08:00', end_working_at: '17:00' }

  include_context 'with auth tokens'

  path '/api/v1/doctors' do
    get('list doctors') do
      tags TAGS_DOCTORS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page'
      parameter name: :first_name, in: :query, type: :string, description: 'Filter by doctor\'s first name'
      parameter name: :last_name, in: :query, type: :string, description: 'Filter by doctor\'s last name'

      response(200, 'successful', response_body_example: true) do
        let(:page) { 1 } # Define default value for page
        let(:per_page) { 5 } # Define default value for per_page
        let(:first_name) { 'John' } # Example filter for first name
        let(:last_name) { 'Cena' } # Example filter for last name

        context 'with no filters' do
          schema '$ref' => '#/components/schemas/doctors'

          run_test!
        end

        context 'with first_name filter' do
          before do
            get '/api/v1/doctors', headers: headers, params: { first_name: doctors.first.first_name }
          end
          run_test!
        end

        context 'with laste_name filter' do
          before do
            get '/api/v1/doctors', headers: headers, params: { last_name: doctors.first.last_name }
          end
          run_test!
        end
      end
    end

    post('create doctor') do
      tags TAGS_DOCTORS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :doctor, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string },
          specialty: { type: :string },
          start_working_at: { type: :string, format: :time },
          end_working_at: { type: :string, format: :time }
        },
        required: %w[first_name last_name specialty start_working_at end_working_at],
        example: {
          doctor: {
            first_name: 'Ulises',
            last_name: 'Largaespada',
            specialty: 'Ortopeda',
            start_working_at: '2000-01-01 05:14:24 UTC',
            end_working_at: '2000-01-01 13:14:24 UTC'
          }
        }
      }

      response(201, 'doctor created', use_as_request_example: true, response_body_example: true) do
        let(:doctor) { valid_attributes }

        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:doctor) { { first_name: '', last_name: '', specialty: '', start_working_at: nil, end_working_at: nil } }

        run_test!
      end
    end
  end

  path '/api/v1/doctors/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Doctor ID'

    get('show doctor') do
      tags TAGS_DOCTORS
      include_context 'authentication parameter headers'
      produces 'application/json'

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/doctor'
        let(:id) { Doctor.create(first_name: 'John', last_name: 'Doe', specialty: 'Cardiology', start_working_at: '08:00', end_working_at: '17:00').id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put('update doctor') do
      tags TAGS_DOCTORS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      parameter name: :doctor, in: :body, schema: {
        type: :object,
        properties: {
          doctor: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string }
            }
          }
        },
        example: {
          doctor: {
            first_name: 'Ulises',
            last_name: 'Largaespada'
          }
        }
      }

      response(200, 'updated', use_as_request_example: true, response_body_example: true) do
        let(:id) { Doctor.create(first_name: 'John', last_name: 'Doe', specialty: 'Cardiology', start_working_at: '08:00', end_working_at: '17:00').id }
        let(:doctor) { { first_name: 'Jane', last_name: 'Smith' } }
        run_test!
      end

      response(404, 'not found', use_as_request_example: true, response_body_example: true) do
        let(:id) { 'invalid' }
        let(:doctor) { {} } # Minimal payload
        run_test!
      end
    end

    delete('delete doctor') do
      tags TAGS_DOCTORS
      include_context 'authentication parameter headers'
      response(204, 'no content') do
        let(:id) { Doctor.create(first_name: 'John', last_name: 'Doe', specialty: 'Cardiology', start_working_at: '08:00', end_working_at: '17:00').id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
