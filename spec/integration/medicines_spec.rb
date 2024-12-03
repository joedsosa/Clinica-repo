require 'swagger_helper'

TAGS_MEDICINES = 'Medicines'.freeze

RSpec.describe 'api/v1/medicines', type: :request do
  let!(:medicines) { create_list(:medicine, 10) }
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  valid_attributes = {
    name: 'Ibuprofen',
    description: 'Pain reliever',
    dosage: '200mg',
    dosage_form: 'Tablet',
    instructions: 'Take with food'
  }

  include_context 'with auth tokens'

  path '/api/v1/medicines' do
    get('list medicines') do
      tags TAGS_MEDICINES
      include_context 'authentication parameter headers'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page'
      parameter name: :name, in: :query, type: :string, description: 'Filter by medicine name'

      response(200, 'successful', response_body_example: true) do
        let(:page) { 1 }
        let(:per_page) { 5 }
        let(:name) { 'Ibuprofen' }

        context 'with no filters' do
          schema '$ref' => '#/components/schemas/medicines'

          run_test!
        end

        context 'with name filter' do
          before do
            get '/api/v1/medicines', headers: headers, params: { name: medicines.first.name }
          end
          run_test!
        end
      end
    end

    post('create medicine') do
      tags TAGS_MEDICINES
      include_context 'authentication parameter headers'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :medicine, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          dosage: { type: :string },
          dosage_form: { type: :string },
          instructions: { type: :string }
        },
        required: %w[name description dosage dosage_form instructions],
        example: {
          medicine: {
            name: 'Paracetamol',
            description: 'Pain reliever',
            dosage: '500mg',
            dosage_form: 'Tablet',
            instructions: 'Take after meals'
          }
        }
      }

      response(201, 'medicine created', use_as_request_example: true, response_body_example: true) do
        let(:medicine) { valid_attributes }

        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:medicine) { { name: '', description: '', dosage: '', dosage_form: '', instructions: '' } }

        run_test!
      end
    end
  end

  path '/api/v1/medicines/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Medicine ID'

    get('show medicine') do
      tags TAGS_MEDICINES
      include_context 'authentication parameter headers'
      produces 'application/json'

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/medicine'
        let(:id) do
          Medicine.create(
            name: 'Ibuprofen',
            description: 'Pain reliever',
            dosage: '200mg',
            dosage_form: 'Tablet',
            instructions: 'Take with food'
          ).id
        end
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put('update medicine') do
      tags TAGS_MEDICINES
      include_context 'authentication parameter headers'
      consumes 'application/json'
      parameter name: :medicine, in: :body, schema: {
        type: :object,
        properties: {
          medicine: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              dosage: { type: :string },
              dosage_form: { type: :string },
              instructions: { type: :string }
            }
          }
        },
        example: {
          medicine: {
            name: 'Paracetamol',
            description: 'Pain reliever',
            dosage: '500mg',
            dosage_form: 'Tablet',
            instructions: 'Take after meals'
          }
        }
      }

      response(200, 'updated', use_as_request_example: true, response_body_example: true) do
        let(:id) do
          Medicine.create(
            name: 'Ibuprofen',
            description: 'Pain reliever',
            dosage: '200mg',
            dosage_form: 'Tablet',
            instructions: 'Take with food'
          ).id
        end
        let(:medicine) { { name: 'Paracetamol', description: 'Pain reliever', dosage: '500mg', dosage_form: 'Tablet', instructions: 'Take after meals' } }
        run_test!
      end

      response(404, 'not found', use_as_request_example: true, response_body_example: true) do
        let(:id) { 'invalid' }
        let(:medicine) { {} }
        run_test!
      end
    end

    delete('delete medicine') do
      tags TAGS_MEDICINES
      include_context 'authentication parameter headers'
      response(204, 'no content') do
        let(:id) do
          Medicine.create(
            name: 'Ibuprofen',
            description: 'Pain reliever',
            dosage: '200mg',
            dosage_form: 'Tablet',
            instructions: 'Take with food'
          ).id
        end
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
