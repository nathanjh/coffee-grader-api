require 'rails_helper'

Rspec.describe 'Roasters API', type: :request do
  let(:roasters) { create_list(:roaster, 5) }
  let(:roaster) { roasters.first }

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
    let(:valid_attributes) { attributes_for(:roaster) }

    context 'with valid attributes' do
      it 'saves a new roaster in the database' do
        expect { post roasters_path, roaster: valid_attributes }.to change(Roaster, :count).by(1)
      end

      it 'returns the roaster' do
        post roasters_path, roaster: valid_attributes
        expect(json['origin']).to eq(valid_attributes[:origin])
      end

      it 'returns status code 201' do
        post roasters_path, roaster: valid_attributes
        expect(response).to have_http_status(201)
      end
    end

    context 'with invalid attributes' do
      it "doesn't save the new roaster in the database" do
        expect { post roasters_path, roaster: { name: nil } }
          .not_to change(Roaster, :count)
      end

      it 'returns status code 422' do
        post roasters_path, roaster: { name: nil }
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        post roasters_path, roaster: { name: nil }
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end




end