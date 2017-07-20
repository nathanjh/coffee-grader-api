require 'rails_helper'

RSpec.describe 'Roasters API', type: :request do
  let!(:roasters) { create_list(:roaster, 5) }
  let(:roaster) { roasters.first }
  let(:roaster_id) { roaster.id }
  let(:user) { create(:user) }

  shared_examples 'restricted access to roasters' do
    it 'returns status code 401' do
      expect(response).to have_http_status(401)
    end

    it 'returns an unauthorized message' do
      expect(response.body).to match(/Authorized users only/)
    end
  end

  describe 'GET /roasters' do
    context 'with valid auth token' do
      before { get roasters_path, headers: auth_headers(user) }

      it 'returns all roasters' do
        expect(json).not_to be_empty
        expect(json['roasters'].size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'without valid auth token' do
      before { get roasters_path }

      it_behaves_like 'restricted access to roasters'
    end
  end

  describe 'GET /roasters/:id' do
    context 'with valid auth token' do
      context 'when the roaster exists' do
        before { get roaster_path(roaster), headers: auth_headers(user) }

        it 'returns the roaster' do
          expect(json).not_to be_empty
          expect(json['roaster']['id']).to eq(roaster.id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the roaster does not exist' do
        before :each do
          roaster_id = 1_000_000
          get "/roasters/#{roaster_id}", headers: auth_headers(user)
        end

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Roaster/)
        end
      end
    end

    context 'without valid auth token' do
      before { get roaster_path(roaster) }

      it_behaves_like 'restricted access to roasters'
    end
  end

  describe 'POST /roasters' do
    let(:valid_attributes) do
      { roaster: { name: 'Cafe Elfie',
                   location: 'Millbrae, CA',
                   website: 'www.cafeelfie.com' } }
    end

    context 'with valid auth token' do
      context 'with valid attributes' do
        before do
          post '/roasters',
               params: valid_attributes,
               headers: auth_headers(user)
        end

        it 'returns the roaster' do
          expect(json['roaster']['location'])
            .to eq(valid_attributes[:roaster][:location])
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'with invalid attributes' do
        it 'returns status code 422' do
          post roasters_path, params: { roaster: { name: nil } },
                              headers: auth_headers(user)
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          post roasters_path, params: { roaster: { name: nil } },
                              headers: auth_headers(user)
          expect(response.body)
            .to match(/Validation failed: Name can't be blank/)
        end
      end
    end

    context 'without valid auth token' do
      before { post roasters_path }

      it_behaves_like 'restricted access to roasters'
    end
  end

  describe 'PATCH /roasters/:id' do
    let(:valid_attributes) { { roaster: { location: 'Carpinteria, CA' } } }

    context 'with valid auth token' do
      context 'when the roaster exists' do
        before do
          patch "/roasters/#{roaster_id}",
                params: valid_attributes,
                headers: auth_headers(user)
        end

        it 'updates the roaster' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end

    context 'without valid auth token' do
      before { patch roaster_path(roaster) }

      it_behaves_like 'restricted access to roasters'
    end
  end

  describe 'DELETE /roasters/:id' do
    context 'with valid auth token' do
      before { delete "/roasters/#{roaster_id}", headers: auth_headers(user) }
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'without valid auth token' do
      before { delete roaster_path(roaster) }

      it_behaves_like 'restricted access to roasters'
    end
  end
end
