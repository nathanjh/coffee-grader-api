require 'rails_helper'

RSpec.describe 'Coffees API', type: :request do
  let(:coffees) { create_list(:coffee, 5) }
  let(:coffee) { coffees.first }

  describe 'GET /coffees' do
    before { get coffees_path }

    it 'returns all coffees' do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
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
    let(:valid_attributes) { attributes_for(:coffee) }

    context 'with valid attirbutes' do
      it 'saves a new coffee in the database' do
        expect { post coffees_path, coffee: valid_attributes }
          .to change(Coffee, :count).by(1)
      end

      it 'returns the coffee' do
        post coffees_path, coffee: valid_attributes
        expect(json['origin']).to eq(valid_attributes[:origin])
      end

      it 'retursn status code 201' do
        post coffees_path, coffee: valid_attributes
        expect(response).to have_http_status(201)
      end
    end

    context 'with invalid attributes' do
      it "doesn't save the new coffee in the database" do
        expect { post coffees_path, coffee: { name: nil } }
          .not_to change(Coffee, :count)
      end

      it 'returns status code 422' do
        post coffees_path, coffee: { name: nil }
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        post coffees_path, coffee: { name: nil }
        expect(response.body)
          .to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  describe 'PATCH /coffees/:id' do
    let(:valid_attributes) { { origin: 'Honduras' } }

    context 'with vaild attributes' do
      it 'updates the coffee record' do
        old_origin = coffee.origin
        expect { patch coffees_path(coffee), coffee: valid_attributes }
          .to change(coffee.origin).from(old_origin).to('Honduras')
      end

      it 'returns the updated coffee record' do
        patch coffees_path(coffee), coffee: valid_attributes
        expect(json['origin']).to eq('Honduras')
      end

      it 'returns status code 204' do
        patch coffees_path(coffee), coffee: valid_attributes
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /coffees/:id' do
    it 'deletes the coffee record from the database' do
      expect { delete coffees_path(coffee) }
        .to change(Coffee, :count).by(-1)
    end
    it 'returns status code 204' do
      delete coffees_path(coffee)
      expect(response).to have_http_status(204)
    end
  end
end
