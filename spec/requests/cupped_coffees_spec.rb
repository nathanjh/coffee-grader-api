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
end
