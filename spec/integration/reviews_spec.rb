# spec/integration/reviews_spec.rb
require 'swagger_helper'

TAGS_REVIEWS = 'Reviews'.freeze

RSpec.describe 'api/v1/reviews', type: :request do
  let!(:reviews) { create_list(:review, 5) }
  let(:user) { create(:user) }
  let(:headers) { user.create_new_auth_token }
  let(:reviews_id) { reviews.first.id }
  let(:valid_attributes) do
    {
      review: {
        email: 'test@example.com',
        first_name: 'John',
        last_name: 'Doe',
        rating: 5,
        title: 'Excellent Service',
        description: 'The service was outstanding!'
      }
    }
  end

  include_context 'with auth tokens'

  path '/api/v1/reviews' do
    get('list reviews') do
      tags TAGS_REVIEWS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page'
      parameter name: :rating, in: :query, type: :integer, description: 'Filter by rating'

      response(200, 'successful', response_body_example: true) do
        let(:page) { 1 }
        let(:per_page) { 5 }
        let(:rating) { 5 }

        context 'with no filters' do
          schema '$ref' => '#/components/schemas/reviews'
          run_test!
        end

        context 'with rating filter' do
          before do
            get '/api/v1/reviews', headers: headers, params: { rating: reviews.first.rating }
          end
          run_test!
        end
        context 'with title filter' do
          before do
            get '/api/v1/reviews', headers: headers, params: { title: reviews.first.title }
          end
          run_test!
        end
        context 'with first_name filter' do
          before do
            get '/api/v1/reviews', headers: headers, params: { first_name: reviews.first.first_name }
          end
          run_test!
        end
      end
    end

    post('create review') do
      tags TAGS_REVIEWS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :review, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          first_name: { type: :string },
          last_name: { type: :string },
          rating: { type: :integer },
          title: { type: :string },
          description: { type: :string }
        },
        required: %w[email first_name last_name rating title description],
        example: {
          review: {
            email: 'john.doe@example.com',
            first_name: 'John',
            last_name: 'Doe',
            rating: 5,
            title: 'Excellent',
            description: 'Great experience!'
          }
        }
      }

      response(201, 'review created', use_as_request_example: true, response_body_example: true) do
        let(:review) { valid_attributes }

        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:review) { { email: '', first_name: '', last_name: '', rating: nil, title: '', description: '' } }

        run_test!
      end
    end
  end

  path '/api/v1/reviews/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Review ID'

    get('show review') do
      tags TAGS_REVIEWS
      include_context 'authentication parameter headers'
      produces 'application/json'

      response(200, 'successful') do
        schema '$ref' => '#/components/schemas/review'
        let(:id) do
          Review.create(email: 'john.doe@example.com', first_name: 'John', last_name: 'Doe', rating: 5, title: 'Excellent', description: 'Great experience!').id
        end
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put('update review') do
      tags TAGS_REVIEWS
      include_context 'authentication parameter headers'
      consumes 'application/json'
      parameter name: :review, in: :body, schema: {
        type: :object,
        properties: {
          review: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              rating: { type: :integer }
            }
          }
        },
        example: {
          review: {
            first_name: 'Jane',
            last_name: 'Smith',
            rating: 4
          }
        }
      }

      response(200, 'updated', use_as_request_example: true, response_body_example: true) do
        let(:id) { reviews.first.id }
        let(:review) { { first_name: 'Jane', last_name: 'Smith', rating: 4 } }
        run_test!
      end

      response(404, 'not found', use_as_request_example: true, response_body_example: true) do
        let(:id) { 'invalid' }
        let(:review) { {} }
        run_test!
      end
    end

    delete('delete review') do
      tags TAGS_REVIEWS
      include_context 'authentication parameter headers'

      response(204, 'no content') do
        let(:id) { reviews.first.id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
