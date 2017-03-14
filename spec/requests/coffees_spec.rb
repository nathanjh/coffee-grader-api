require 'rails_helper'

RSpec.describe 'Coffees API', type: :request do
  let!(:coffees) { [create(:coffee), create(:coffee, name: 'Hunapu')] }
  let(:coffee) { coffees.first }

  describe 'GET /coffees' do
    before { get coffees_path }

    it 'returns all coffees' do
      expect(json).not_to be_empty
      expect(json.size).to eq(2)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /coffees/:id' do
    context 'when the coffee exists' do
      before { get coffee_path(coffee) }

      it 'returns the coffee' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(coffee.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the coffee does not exist' do
      before :each do
        coffee_id = 1_000_000
        get "/coffees/#{coffee_id}"
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Coffee/)
      end
    end
  end

  describe 'POST /coffees' do
    let(:valid_attributes) { attributes_for(:coffee, name: 'El Diamante') }

    context 'with valid attributes' do
      it 'returns the coffee' do
        post coffees_path, params: valid_attributes
        expect(json['origin']).to eq(valid_attributes[:origin])
      end

      it 'returns status code 201' do
        post coffees_path, params: valid_attributes
        expect(response).to have_http_status(201)
      end
    end

    context 'with invalid attributes' do
      before :each do
        post coffees_path, params: { name: nil }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'PATCH /coffees/:id' do
    let(:valid_attributes) { { origin: 'Honduras' } }

    context 'with vaild attributes' do
      it 'updates the coffee' do
        patch coffee_path(coffee), params: valid_attributes
        updated_coffee = Coffee.find(coffee.id)
        expect(updated_coffee.origin).to eq('Honduras')
      end

      it 'returns status code 204' do
        patch coffee_path(coffee), params: valid_attributes
        expect(response).to have_http_status(204)
      end
    end

    context 'with invalid attributes' do
      before :each do
        Coffee.create!(name: 'El Limon',
                       origin: 'Guatemala',
                       producer: 'Beneficio Bella Vista')
        patch coffee_path(coffee), params: { name: 'El Limon' }
      end
      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed:/)
      end

      it 'returns staus code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE /coffees/:id' do
    it 'returns status code 204' do
      delete coffee_path(coffee)
      expect(response).to have_http_status(204)
    end
  end
end
