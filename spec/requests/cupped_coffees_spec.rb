require 'rails_helper'

RSpec.describe 'CuppedCoffees API', type: :request do
  let(:cupping) { create(:cupping) }
  let(:coffee) { create(:coffee) }
  let(:roaster) { create(:roaster) }
  let(:cupped_coffees) do
    [CuppedCoffee.create!(roast_date: DateTime.now - 1,
                          coffee_alias: Faker::Lorem.characters(7),
                          cupping_id: cupping.id,
                          roaster_id: roaster.id,
                          coffee_id: Coffee.create!(name: 'Aragon',
                                                    origin: 'Colombia',
                                                    producer: 'Beneficio Bella Vista').id),
     CuppedCoffee.create!(roast_date: DateTime.now - 1,
                          coffee_alias: Faker::Lorem.characters(7),
                          cupping_id: cupping.id,
                          roaster_id: roaster.id,
                          coffee_id: coffee.id)]
  end
  let(:cupped_coffee) { cupped_coffees.first }

  describe 'GET /cuppings/:cupping_id/cupped_coffees' do
    before do
      cupped_coffees
      get cupping_cupped_coffees_path(cupping)
    end

    it 'returns all cupped_coffees' do
      expect(json).not_to be_empty
      expect(json.size).to eq(2)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /cuppings/:cupping_id/cuppped_coffees/:id' do
    context 'when the cupped_coffee exists' do
      before do
        cupped_coffees
        get cupping_cupped_coffee_path(cupping, cupped_coffee)
      end

      it 'returns the cupped_coffee' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(cupped_coffee.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the cupped_coffee does not exist' do
      before :each do
        cupped_coffee_id = 1_000_000
        get "/cuppings/#{cupping.id}/cupped_coffees/#{cupped_coffee_id}"
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find CuppedCoffee/)
      end
    end
  end

  describe 'POST /cuppings/:cupping_id/cupped_coffees/' do
    let(:valid_attributes) do
      { roast_date: DateTime.now - 2,
        coffee_alias: 'Sample Alvarius B',
        cupping_id: cupping.id,
        roaster_id: roaster.id,
        coffee_id: coffee.id }
    end

    context 'with valid attributes' do
      before :each do
        post cupping_cupped_coffees_path(cupping), params:
          { cupped_coffee: valid_attributes }
      end

      it 'returns the coffee' do
        expect(json['coffee_alias']).to eq('Sample Alvarius B')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'with invaild attributes' do
      before :each do
        post cupping_cupped_coffees_path(cupping), params: { cupped_coffee:
                                                              { roast_date: nil,
                                                                coffee_id: nil } }
      end

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Coffee must exist, Roaster must exist/)
      end
    end
  end
end
