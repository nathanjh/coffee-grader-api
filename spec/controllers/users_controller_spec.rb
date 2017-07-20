require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  # describe 'GET #index' do
  #   context 'when signed-in' do
  #     login_user
  #
  #     it 'returns a successful 200 response' do
  #       get :index, format: :json
  #       expect(response).to be_success
  #       expect(response).to have_http_status(200)
  #     end
  #
  #     it 'collects all users into @users' do
  #       users = create_list(:user, 5)
  #       get :index, format: :JSON
  #       expect(assigns(:users)).to eq users
  #     end
  #
  #     it "returns a list of all users' names" do
  #       users = create_list(:user, 5)
  #       get :index, format: :JSON
  #       parsed_response = JSON.parse(response.body)
  #       expect(parsed_response['users'].length).to eq users.length
  #     end
  #   end
  # end

  describe 'GET #show' do
    let(:requested_user) { create(:user) }

    context 'when signed-in' do
      before :each do
        login_user(requested_user)
      end

      it 'returns a successful 200 response' do
        get :show, params: { id: requested_user }, format: :json
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'returns the data for requested user' do
        get :show, params: { id: requested_user }, format: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['user']['id']).to eq requested_user.id
        expect(parsed_response['user']['email']).to eq requested_user.email
      end

      it 'returns an error message when user does not exist' do
        get :show, params: { id: 1_000_000_000 }, format: :json
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['message']).to match(/Couldn't find User/)
        expect(response).to have_http_status(404)
      end
    end

    context 'when not signed-in' do
      it 'returns a 401 unauthorized error' do
        get :show, params: { id: requested_user }, format: :json
        parsed_response = JSON.parse(response.body)
        expect(response).to_not be_success
        expect(response).to have_http_status(401)
        expect(parsed_response['errors']).to include 'Authorized users only.'
      end
    end
  end
end
