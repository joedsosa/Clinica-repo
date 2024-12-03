# spec/integration/subscriptions_spec.rb
require 'swagger_helper'

TAGS_SUBSCRIPTIONS = 'Subscriptions'.freeze

RSpec.describe 'api/v1/subscriptions', type: :request do
  let!(:subscriptions) { create_list(:subscription, 5) }
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let(:valid_attributes) do
    {
      subscription: {
        email: 'test@example.com',
        first_name: 'John',
        last_name: 'Doe',
        terms_and_conditions: true
      }
    }
  end

  include_context 'with auth tokens'

  path '/api/v1/subscriptions' do
    get('list subscriptions') do
      tags TAGS_SUBSCRIPTIONS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page'
      parameter name: :email, in: :query, type: :string, description: 'Filter by email'

      response(200, 'successful', response_body_example: true) do
        let(:page) { 1 }
        let(:per_page) { 5 }
        let(:email) { 'example' }

        context 'with no filters' do
          schema '$ref' => '#/components/schemas/subscriptions'
          run_test!
        end

        context 'with email filter' do
          before do
            get '/api/v1/subscriptions', headers: headers, params: { email: subscriptions.first.email }
          end
          run_test!
        end
        context 'with first name filter' do
          before do
            get '/api/v1/subscriptions', headers: headers, params: { first_name: subscriptions.first.first_name }
          end
          run_test!
        end
        context 'with last name filter' do
          before do
            get '/api/v1/subscriptions', headers: headers, params: { last_name: subscriptions.first.last_name }
          end
          run_test!
        end
      end
    end

    post('create subscription') do
      tags TAGS_SUBSCRIPTIONS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :subscription, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          first_name: { type: :string },
          last_name: { type: :string },
          terms_and_conditions: { type: :boolean }
        },
        required: %w[email first_name last_name terms_and_conditions],
        example: {
          subscription: {
            email: 'john.doe@example.com',
            first_name: 'John',
            last_name: 'Doe',
            terms_and_conditions: true
          }
        }
      }

      response(201, 'subscription created', use_as_request_example: true, response_body_example: true) do
        let(:subscription) { valid_attributes }

        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:subscription) { { email: '', first_name: '', last_name: '', terms_and_conditions: nil } }

        run_test!
      end
    end
  end

  path '/api/v1/subscriptions/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Subscription ID'

    get('show subscription') do
      tags TAGS_SUBSCRIPTIONS
      include_context 'authentication parameter headers'
      produces 'application/json'

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/subscription'
        let(:id) { subscriptions.first.id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put('update subscription') do
      tags TAGS_SUBSCRIPTIONS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      parameter name: :subscription, in: :body, schema: {
        type: :object,
        properties: {
          subscription: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              terms_and_conditions: { type: :boolean }
            }
          }
        },
        example: {
          subscription: {
            first_name: 'Jane',
            last_name: 'Smith',
            terms_and_conditions: true
          }
        }
      }

      response(200, 'updated', use_as_request_example: true, response_body_example: true) do
        let(:id) { subscriptions.first.id }
        let(:subscription) { { first_name: 'Jane', last_name: 'Smith', terms_and_conditions: true } }
        run_test!
      end

      response(404, 'not found', use_as_request_example: true, response_body_example: true) do
        let(:id) { 'invalid' }
        let(:subscription) { {} }
        run_test!
      end
    end

    delete('delete subscription') do
      tags TAGS_SUBSCRIPTIONS
      include_context 'authentication parameter headers'

      response(204, 'no content') do
        let(:id) { subscriptions.first.id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
