require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
  describe 'POST auth/sign_in' do
    context 'when signing up with valid credentials' do
      before do
        @user = create(:user)
        post '/auth/sign_in',
             params: { email: @user.email, password: @user.password }
      end
      it 'returns the user' do
        expect(json['user']['email']).to eq @user.email
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
