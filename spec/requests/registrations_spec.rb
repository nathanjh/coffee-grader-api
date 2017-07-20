require 'rails_helper'

RSpec.describe 'Registrations API', type: :request do
  describe 'POST /auth' do
    context 'when signing up with valid params and valid invite token' do
      before do
        post '/auth', params: attributes_for(:user, invite_token: 'abc')
      end
      it 'returns the user' do
        expect(json['user']['invite_token']).to eq 'abc'
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
