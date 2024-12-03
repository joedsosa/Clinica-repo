require 'rails_helper'

RSpec.describe 'Reviews API', type: :request do
  let(:user) { create(:user) }
  let!(:reviews) { create_list(:review, 5) }
  let(:review_id) { reviews.first.id }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  let(:valid_headers) do
    user.create_new_auth_token.merge('Content-Type' => 'application/json')
  end

  describe 'GET /api/v1/reviews' do
    it 'returns a list of reviews with pagination' do
      get '/api/v1/reviews', headers: valid_headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body).to have_key('data')
      expect(response_body['data'].size).to be <= 5
      expect(response_body).to have_key('meta')
      expect(response_body['meta']).to have_key('pagination')
    end
  end

  describe 'GET /api/v1/reviews?rating=5' do
    let!(:high_rating_review) { create(:review, rating: 5) }

    it 'returns reviews filtered by rating' do
      get '/api/v1/reviews?rating=5', headers: valid_headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body).to have_key('data')
      expect(response_body['data'].all? { |r| r['rating'] == 5 }).to eq(true)
    end
  end

  describe 'GET /api/v1/reviews/:id' do
    context 'when the review exists' do
      it 'returns the review' do
        get "/api/v1/reviews/#{review_id}", headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('data')
        expect(response_body['data']['id']).to eq(review_id)
      end
    end

    context 'when the review does not exist' do
      it 'returns a not found error' do
        get '/api/v1/reviews/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v1/reviews' do
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
      }.to_json
    end

    let(:invalid_attributes) do
      {
        review: {
          email: '',
          first_name: '',
          last_name: '',
          rating: '',
          title: '',
          description: ''
        }
      }.to_json
    end

    context 'when the request is valid' do
      it 'creates a new review' do
        post '/api/v1/reviews', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:created)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('id')
        expect(response_body['first_name']).to eq('John')
      end
    end

    context 'when the request is invalid' do
      it 'returns an unprocessable entity status' do
        post '/api/v1/reviews', params: invalid_attributes, headers: valid_headers

        expect(response).to have_http_status(:unprocessable_entity)
        response_body = JSON.parse(response.body)
        expect(response_body).to have_key('email')
        expect(response_body['email']).to include("can't be blank")
      end
    end
  end

  describe 'PUT /api/v1/reviews/:id' do
    let(:valid_attributes) do
      {
        review: {
          first_name: 'Jane',
          last_name: 'Smith',
          rating: 4
        }
      }.to_json
    end

    context 'when the review exists' do
      it 'updates the review' do
        put "/api/v1/reviews/#{review_id}", params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['first_name']).to eq('Jane')
        expect(response_body['last_name']).to eq('Smith')
        expect(response_body['rating']).to eq(4)
      end
    end

    context 'when the review does not exist' do
      it 'returns a not found error' do
        put '/api/v1/reviews/999', params: valid_attributes, headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /api/v1/reviews/:id' do
    context 'when the review exists' do
      it 'deletes the review' do
        expect do
          delete "/api/v1/reviews/#{review_id}", headers: valid_headers
        end.to change { Review.count }.by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the review does not exist' do
      it 'returns a not found error' do
        delete '/api/v1/reviews/999', headers: valid_headers

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
