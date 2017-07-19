require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { create(:user) }

  shared_examples 'restricted access to users' do
    it 'returns status code 401' do
      expect(response).to have_http_status(401)
    end

    it 'returns an unauthorized message' do
      expect(response.body).to match(/Authorized users only/)
    end
  end

  describe 'GET /users/:id' do
    context 'with valid auth token' do
      context 'when user exists' do
        before do
          get user_path(user),
              headers: auth_headers(user)
        end

        it 'returns the user' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(user.id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the user does not exist' do
        before :each do
          user_id = 1_000_000
          get "/users/#{user_id}",
              headers: auth_headers(user)
        end

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find User/)
        end
      end
    end

    context 'without valid auth token' do
      before { get user_path(user) }

      it_behaves_like 'restricted access to users'
    end
  end

  describe 'GET /search' do
    before(:example) { create_list(:user, 10) }
    context 'with valid auth token' do
      context 'when matching records exist' do
        before :each do
          get '/users/search',
              headers: auth_headers(user),
              # let's make sure we get some hits
              params: { term: '@' }
        end

        it 'returns a collection of users' do
          expect(json).not_to be_empty
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end
      context 'when no records match' do
        before :each do
          get '/users/search',
              headers: auth_headers(user),
              params: { term: 'nowaythiscouldpossiblymatch' }
        end
        it 'returns an empty array' do
          expect(json['users']).to be_empty
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end
      context 'with pagination params passed in' do
        it 'limits the results per page' do
          get '/users/search', headers: auth_headers(user),
                               params: { term: '@', limit: 5 }
          expect(json.length).to eq 5
        end
        it 'returns records determined by page number' do
          get '/users/search', headers: auth_headers(user),
                               params: { term: '@', limit: 7, page: 2 }
          # since there are eleven matching records (all ten we created plus our
          # user, and our records per page is 7, then the second page should have
          # four records
          expect(json.length).to eq 4
        end
      end
      context 'when route is visited with no query' do
        before(:example) { get search_users_path, headers: auth_headers(user) }

        it 'returns an empty array' do
          expect(json['users']).to be_empty
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end
    end
    context 'without valid auth token' do
      before(:example) { get search_users_path }

      it_behaves_like 'restricted access to users'
    end
  end
end
