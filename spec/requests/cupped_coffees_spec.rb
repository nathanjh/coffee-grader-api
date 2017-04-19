require 'rails_helper'

RSpec.describe 'CuppedCoffees API', type: :request do
  let(:cupping) { create(:cupping) }
  let(:host) { User.find(cupping.host_id) }
  let(:coffee) { create(:coffee) }
  let(:roaster) { create(:roaster) }
  let(:cupped_coffees) { create_list(:cupped_coffee, 2, cupping_id: cupping.id) }
  let(:cupped_coffee) { cupped_coffees.first }

  shared_examples 'restricted access to cupped_coffees' do
    it 'returns status code 401' do
      expect(response).to have_http_status(401)
    end

    it 'returns an unauthorized message' do
      expect(response.body).to match(/Authorized users only/)
    end
  end

  shared_examples 'restricted access when cupping is closed' do
    it 'returns status code 400' do
      expect(response).to have_http_status(400)
    end

    it 'returns an error message' do
      expect(response.body).to match(/Cupping is closed/)
    end
  end

  describe 'GET /cuppings/:cupping_id/cupped_coffees' do
    context 'with valid auth token' do
      before do
        cupped_coffees
        get cupping_cupped_coffees_path(cupping),
            headers: auth_headers(host)
      end

      it 'returns all cupped_coffees' do
        expect(json).not_to be_empty
        expect(json.size).to eq(2)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'without valid auth token' do
      before { get cupping_cupped_coffees_path(cupping) }

      it_behaves_like 'restricted access to cupped_coffees'
    end
  end

  describe 'GET /cuppings/:cupping_id/cuppped_coffees/:id' do
    context 'with valid auth token' do
      context 'when the cupped_coffee exists' do
        before do
          cupped_coffees
          get cupping_cupped_coffee_path(cupping, cupped_coffee),
              headers: auth_headers(host)
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
          get "/cuppings/#{cupping.id}/cupped_coffees/#{cupped_coffee_id}",
              headers: auth_headers(host)
        end

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find CuppedCoffee/)
        end
      end
    end

    context 'without valid auth token' do
      before { get cupping_cupped_coffee_path(cupping, cupped_coffee) }

      it_behaves_like 'restricted access to cupped_coffees'
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

    context 'with valid auth token' do
      context 'with valid attributes' do
        before :each do
          post cupping_cupped_coffees_path(cupping),
               params: { cupped_coffee: valid_attributes },
               headers: auth_headers(host)
        end

        it 'returns the coffee' do
          expect(json['coffee_alias']).to eq('Sample Alvarius B')
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'with invalid attributes' do
        before :each do
          post cupping_cupped_coffees_path(cupping),
               params: { cupped_coffee: { roast_date: nil,
                                          coffee_id: nil } },
               headers: auth_headers(host)
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

    context 'without valid auth token' do
      before { post cupping_cupped_coffees_path(cupping) }

      it_behaves_like 'restricted access to cupped_coffees'
    end

    context 'when cupping is closed' do
      before :each do
        cupping.update(open: false)
        post cupping_cupped_coffees_path(cupping),
             params: { cupped_coffee: { roast_date: nil,
                                        coffee_id: nil } },
             headers: auth_headers(host)
      end

      it_behaves_like 'restricted access when cupping is closed'
    end
  end

  describe 'PATCH /cuppings/:cupping_id/cupped_coffees/:id' do
    let(:valid_attributes) { { coffee_alias: 'Late November' } }

    context 'with valid auth token' do
      context 'with valid attributes' do
        before :each do
          patch cupping_cupped_coffee_path(cupping, cupped_coffee),
                params: { cupped_coffee: valid_attributes },
                headers: auth_headers(host)
        end
        it 'updates the cupped_coffee' do
          updated_cupped_coffee = CuppedCoffee.find(cupped_coffee.id)
          expect(updated_cupped_coffee.coffee_alias).to eq('Late November')
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end

      context 'with invalid attributes' do
        before :each do
          patch cupping_cupped_coffee_path(cupping, cupped_coffee),
                params: { cupped_coffee: { roaster_id: 1_000_000 } },
                headers: auth_headers(host)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/Validation failed:/)
        end

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'without valid auth token' do
      before { patch cupping_cupped_coffee_path(cupping, cupped_coffee) }

      it_behaves_like 'restricted access to cupped_coffees'
    end

    context 'when cupping is closed' do
      before :each do
        cupping.update(open: false)
        patch cupping_cupped_coffee_path(cupping, cupped_coffee),
              params: { cupped_coffee: valid_attributes },
              headers: auth_headers(host)
      end

      it_behaves_like 'restricted access when cupping is closed'
    end
  end

  describe 'DELETE /cuppings/:cupping_id/cupped_coffees/:id' do
    context 'with valid auth token' do
      it 'returns status code 204' do
        delete "/cuppings/#{cupping.id}/cupped_coffees/#{cupped_coffee.id}",
               headers: auth_headers(host)
        expect(response).to have_http_status(204)
      end
    end

    context 'without valid auth token' do
      before { delete cupping_cupped_coffee_path(cupping, cupped_coffee) }

      it_behaves_like 'restricted access to cupped_coffees'
    end

    context 'when cupping is closed' do
      before :each do
        cupping.update(open: false)
        delete "/cuppings/#{cupping.id}/cupped_coffees/#{cupped_coffee.id}",
               headers: auth_headers(host)
      end

      it_behaves_like 'restricted access when cupping is closed'
    end
  end
end
