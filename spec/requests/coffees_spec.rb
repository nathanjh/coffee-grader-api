require 'rails_helper'

RSpec.describe 'Coffees API', type: :request do
  let!(:coffees) { create_list(:coffee, 5) }
  let(:coffee) { coffees.first }

  shared_examples 'restricted access to coffees' do
    it 'returns status code 401' do
      expect(response).to have_http_status(401)
    end

    it 'returns an unauthorized message' do
      expect(response.body).to match(/Authorized users only/)
    end
  end

  describe 'GET /coffees' do
    context 'with valid auth token' do
      before :each do
        get coffees_path, headers: auth_headers(create(:user))
      end

      it 'returns all coffees' do
        expect(json['coffees']).not_to be_empty
        expect(json['coffees'].size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'without valid auth token' do
      before { get coffees_path }

      it_behaves_like 'restricted access to coffees'
    end
  end

  describe 'GET /coffees/:id' do
    context 'with valid auth token' do
      context 'when the coffee exists' do
        before { get coffee_path(coffee), headers: auth_headers(create(:user)) }

        it 'returns the coffee' do
          expect(json['coffee']).not_to be_empty
          expect(json['coffee']['id']).to eq(coffee.id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the coffee does not exist' do
        before :each do
          coffee_id = 1_000_000
          get "/coffees/#{coffee_id}", headers: auth_headers(create(:user))
        end

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Coffee/)
        end
      end
    end

    context 'without valid auth token' do
      before { get coffees_path(coffee) }

      it_behaves_like 'restricted access to coffees'
    end
  end

  describe 'POST /coffees' do
    let(:valid_attributes) do
      { coffee: attributes_for(:coffee, name: 'El Diamante') }
    end

    context 'with valid auth token' do
      context 'with valid attributes' do
        it 'returns the coffee' do
          post coffees_path, headers: auth_headers(create(:user)),
                             params: valid_attributes
          expect(json['coffee']['origin'])
            .to eq(valid_attributes[:coffee][:origin])
        end

        it 'returns status code 201' do
          post coffees_path, headers: auth_headers(create(:user)),
                             params: valid_attributes
          expect(response).to have_http_status(201)
        end
      end

      context 'with invalid attributes' do
        before :each do
          post coffees_path, headers: auth_headers(create(:user)),
                             params: { coffee: { name: nil } }
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

    context 'without valid auth token' do
      before { post coffees_path }

      it_behaves_like 'restricted access to coffees'
    end
  end

  describe 'PATCH /coffees/:id' do
    let(:valid_attributes) { { coffee: { origin: 'Honduras' } } }

    context 'with valid auth token' do
      context 'with valid attributes' do
        it 'updates the coffee' do
          patch coffee_path(coffee), params: valid_attributes,
                                     headers: auth_headers(create(:user))
          updated_coffee = Coffee.find(coffee.id)
          expect(updated_coffee.origin).to eq('Honduras')
        end

        it 'returns status code 204' do
          patch coffee_path(coffee), params: valid_attributes,
                                     headers: auth_headers(create(:user))
          expect(response).to have_http_status(204)
        end
      end

      context 'with invalid attributes' do
        before :each do
          Coffee.create!(name: 'El Limon',
                         origin: 'Guatemala',
                         producer: 'Beneficio Bella Vista')
          patch coffee_path(coffee),
                params: { coffee: { name: 'El Limon',
                                    origin: 'Guatemala',
                                    producer: 'Beneficio Bella Vista' } },
                headers: auth_headers(create(:user))
        end
        it 'returns a validation failure message' do
          expect(response.body).to match(/Validation failed:/)
        end

        it 'returns staus code 422' do
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'without valid auth token' do
      before { patch coffee_path(coffee) }

      it_behaves_like 'restricted access to coffees'
    end
  end

  describe 'DELETE /coffees/:id' do
    context 'with valid auth token' do
      it 'returns status code 204' do
        delete coffee_path(coffee), headers: auth_headers(create(:user))
        expect(response).to have_http_status(204)
      end
    end

    context 'without valid auth token' do
      before { delete coffee_path(coffee) }
      it_behaves_like 'restricted access to coffees'
    end
  end
end
