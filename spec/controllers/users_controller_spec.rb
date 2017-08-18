require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:requested_user) { create(:user) }
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
  describe 'GET #index' do
    context 'when signed-in' do
      before(:each) { login_user(requested_user) }

      context 'when given a valid uid param matching uid auth header' do
        before(:each) { get :index, params: { uid: requested_user.uid } }

        it 'returns a successful 200 response' do
          expect(response).to have_http_status(200)
        end
        it 'returns the basic user data' do
          expect(assigns(:user)).to eq requested_user
        end
      end

      context 'with an invalid uid param' do
        it 'returns a 404 not found error' do
          get :index, params: { uid: 'some_nonmatching_uid' }
          expect(response).to have_http_status(404)
        end
      end

      context 'when uid param is valid, but does not match uid auth header' do
        before(:each) { @user2 = create(:user) }
        it 'returns a 400 bad request error' do
          get :index, params: { uid: @user2.uid }
          expect(response).to have_http_status(400)
        end
      end

      context 'when no uid is passed as a param' do
        it 'returns a 400 bad request error' do
          get :index
          expect(response).to have_http_status(400)
        end
      end
    end

    context 'when not signed-in' do
      it 'returns a 401 unauthorized error' do
        get :index
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET #show' do
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
