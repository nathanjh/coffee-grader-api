require 'rails_helper'

RSpec.describe 'Roasters API', type: :request do
  let!(:roasters) { create_list(:roaster, 5) }
  let(:roaster) { roasters.first }
  let(:roaster_id) { roaster.id }

  describe 'GET /roasters' do
    before { get roasters_path }

    it 'returns all roasters' do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /roasters/:id' do
    context 'when the roaster exists' do
      before { get roaster_path(roaster) }

      it 'returns the roaster' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(roaster.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the roaster does not exist' do
      before :each do
        roaster_id = 1_000_000
        get "/roasters/#{roaster_id}"
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Roaster/)
      end
    end
  end

  describe 'POST /roasters' do
    let(:valid_attributes) { { name: 'Cafe Elfie', location: 'Millbrae, CA', website: 'www.cafeelfie.com' } }

    context 'with valid attributes' do
      before { post '/roasters', params: valid_attributes }

      it 'returns the roaster' do
        expect(json['location']).to eq(valid_attributes[:location])
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'with invalid attributes' do
      it 'returns status code 422' do
        post roasters_path, params: { roaster: { name: nil }}
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        post roasters_path, params: { roaster: { name: nil }}
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'PATCH /roasters/:id' do
    let(:valid_attributes) { { location: 'Carpinteria, CA' } }

    context 'when the roaster exists' do
      before { patch "/roasters/#{roaster_id}", params: valid_attributes }

      it 'updates the roaster' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /roasters/:id' do
    before { delete "/roasters/#{roaster_id}" }
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end