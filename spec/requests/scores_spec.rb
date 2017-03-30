require 'rails_helper'

RSpec.describe 'Scores API', type: :request do
  let(:cupping) { create(:cupping) }
  let(:host) { User.find(cupping.host_id) }
  let(:cupped_coffee) { create(:cupped_coffee, cupping_id: cupping.id) }
  let(:graders) { create_list(:user, 5) }
  let(:scores) do
    graders.map do |grader|
      create(:score, grader_id: grader.id,
                     cupped_coffee_id: cupped_coffee.id,
                     cupping_id: cupping.id)
    end
  end
  let(:score) { scores.first }
  let(:score_id) { score.id }

  shared_examples 'restricted access to scores' do
    it 'returns status code 401' do
      expect(response).to have_http_status(401)
    end

    it 'returns an unauthorized message' do
      expect(response.body).to match(/Authorized users only/)
    end
  end

  describe 'GET /scores' do
    context 'with valid auth token' do
      before do
        scores
        get scores_path, headers: auth_headers(host)
      end

      it 'returns all scores' do
        expect(json).not_to be_empty
        expect(json.size).to eq(5)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'without valid auth token' do
      before { get scores_path }

      it_behaves_like 'restricted access to scores'
    end
  end

  describe 'GET /scores/:id' do
    context 'with valid auth token' do
      context 'when the score exists' do
        before { get score_path(score), headers: auth_headers(host) }

        it 'returns the score' do
          expect(json).not_to be_empty
          expect(json['id']).to eq(score.id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end

      context 'when the score does not exist' do
        before :each do
          score_id = 1_000_000
          get "/scores/#{score_id}", headers: auth_headers(host)
        end

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end

        it 'returns a not found message' do
          expect(response.body).to match(/Couldn't find Score/)
        end
      end
    end

    context 'without valid auth token' do
      before { get score_path(score) }

      it_behaves_like 'restricted access to scores'
    end
  end

  describe 'POST /scores' do
    let(:valid_attributes) do
      attributes_for(:score,
                     cupping_id: cupping.id,
                     cupped_coffee_id: cupped_coffee.id,
                     grader_id: graders.first.id)
    end
    context 'with valid auth token' do
      context 'with valid attributes' do
        before do
          post '/scores', params: valid_attributes, headers: auth_headers(host)
        end

        it 'returns the score' do
          expect(json['notes']).to eq(valid_attributes[:notes])
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'with invalid attributes' do
        # FactoryGirl.attributes_for doesn't generate foreign keys
        it 'returns status code 422' do
          post scores_path, params: attributes_for(:score),
                            headers: auth_headers(host)
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          post scores_path, params: attributes_for(:score),
                            headers: auth_headers(host)
          expect(response.body)
            .to match(/Validation failed: Grader must exist, Cupped coffee must exist, Cupping must exist, Grader can't be blank, Cupping can't be blank, Cupped coffee can't be blank/)
        end
      end
    end

    context 'without valid auth token' do
      before { post scores_path }

      it_behaves_like 'restricted access to scores'
    end
  end

  describe 'PATCH /scores/:id' do
    let(:valid_attributes) { { acidity: 3 } }

    context 'with valid auth token' do
      context 'when the score exists' do
        before do
          patch "/scores/#{score_id}", params: valid_attributes,
                                       headers: auth_headers(host)
        end

        it 'updates the score' do
          expect(response.body).to be_empty
        end

        it 'returns status code 204' do
          expect(response).to have_http_status(204)
        end
      end
    end

    context 'without valid auth token' do
      before { patch score_path(score) }

      it_behaves_like 'restricted access to scores'
    end
  end

  describe 'DELETE /scores/:id' do
    context 'with valid auth token' do
      before { delete "/scores/#{score_id}", headers: auth_headers(host) }
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'without valid auth token' do
      before { delete score_path(score) }

      it_behaves_like 'restricted access to scores'
    end
  end
end
