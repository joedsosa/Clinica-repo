# shared_contexts.rb
RSpec.shared_context 'with auth tokens' do
  let(:user_to_log_in) { FactoryBot.create(:user, password: 'password') }

  let(:tokens) do
    token = DeviseTokenAuth::TokenFactory.create
    user_to_log_in.tokens[token.client] = {
      token: token.token_hash,
      expiry: token.expiry
    }
    user_to_log_in.save!
    user_to_log_in.build_auth_headers(token.token, token.client)
  end

  let!(:client) { tokens['client'] }
  let!('access-token') { tokens['access-token'] }
  let!(:uid) { tokens['uid'] }
end

RSpec.shared_context 'login user' do
  let(:user) { create(:user) }

  before do
    authenticate_user(user)
  end
end

RSpec.shared_examples 'authentication parameter headers' do
  parameter name: 'access-token', in: :header, type: :string
  parameter name: 'client', in: :header, type: :string
  parameter name: 'uid', in: :header, type: :string
end
