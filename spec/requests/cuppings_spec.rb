require 'rails_helper'

RSpec.describe 'Cuppings API', type: :request do
  let(:user) { create(:user) }
  let!(:cuppings) { create_list(:cupping, 5) }
  let(:cupping) { cuppings.first }
  let(:cupping_id) { cupping.id }

  shared_examples 'restricted access to cuppings' do
    it 'returns status code 401' do
      expect(response).to have_http_status(401)
    end

    it 'returns an unauthorized message' do
      expect(response.body).to match(/Authorized users only/)
    end
  end

  describe 'GET /cuppings' do
    context 'with vaild auth token' do
      before { get cuppings_path, headers: auth_headers(user) }

      it 'returns all cuppings' do
        expect(json).not_to be_empty
        expect(json.size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'without valid auth token' do
      before { get cuppings_path }

      it_behaves_like 'restricted access to cuppings'
    end
  end

  describe 'GET /cuppings/:id' do
    context 'with valid auth token' do
      context 'when the cupping exists' do
        before { get cupping_path(cupping), headers: auth_headers(user) }

        it 'returns the cupping' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(cupping_id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the cupping does not exist' do
        before :each do
          cupping_id = 1_000_000
          get "/cuppings/#{cupping_id}", headers: auth_headers(user)
        end

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Cupping/)
        end
      end

      context 'without valid auth token' do
        before { get cupping_path(cupping) }

        it_behaves_like 'restricted access to cuppings'
      end
    end
  end

  describe 'POST /cuppings' do
    let(:valid_attributes) { { host_id: user.id, location: 'San Francisco, CA', cup_date: Time.now, cups_per_sample: 3 } }

    context 'with valid auth token' do
      context 'with valid attributes' do
        before do
          post '/cuppings', params: valid_attributes,
                            headers: auth_headers(user)
        end

        it 'returns the cupping' do
          expect(json['location']).to eq(valid_attributes[:location])
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'with invalid attributes' do
        before do
          post cuppings_path, params: { cupping: { name: nil, location: nil } },
                              headers: auth_headers(user)
        end

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body)
            .to match(/Validation failed: Host must exist, Location can't be blank, Cup date can't be blank, Cups per sample can't be blank, Host can't be blank/)
        end
      end

      context 'without valid auth token' do
        before { get cupping_path(cupping) }

        it_behaves_like 'restricted access to cuppings'
      end
    end
  end

  describe 'PATCH /cuppings/:id' do
    let(:valid_attributes) { { location: 'Shoreline, WA' } }

    context 'with vaild auth token' do
      context 'when the cupping exists' do
        before do
          patch "/cuppings/#{cupping_id}", params: valid_attributes,
                                           headers: auth_headers(user)
        end

        it 'updates the cupping' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end

      context 'without valid auth token' do
        before { get cupping_path(cupping) }

        it_behaves_like 'restricted access to cuppings'
      end
    end
  end

  describe 'DELETE /cuppings/:id' do
    before { delete "/cuppings/#{cupping_id}", headers: auth_headers(user) }
    context 'with valid auth token' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'without valid auth token' do
      before { get cupping_path(cupping) }

      it_behaves_like 'restricted access to cuppings'
    end
  end
end
