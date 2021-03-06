require 'rails_helper'

RSpec.describe 'Scores API', type: :request do
  let(:cupping) { create(:cupping) }
  let(:host) { User.find(cupping.host_id) }
  let(:cupped_coffee) { create(:cupped_coffee, cupping_id: cupping.id) }
  let(:graders) { create_list(:user, 5) }
  let(:grader) { graders.first }
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

  shared_examples 'restricted access when cupping is closed' do
    it 'returns status code 400' do
      expect(response).to have_http_status(400)
    end

    it 'returns an error message' do
      expect(response.body).to match(/Cupping is closed/)
    end
  end

  describe 'GET /scores' do
    context 'with valid auth token' do
      before do
        scores
        get scores_path, headers: auth_headers(host)
      end

      it 'returns all scores' do
        expect(json['scores']).not_to be_empty
        expect(json['scores'].size).to eq(5)
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
          expect(json['score']).not_to be_empty
          expect(json['score']['id']).to eq(score.id)
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
      { score: attributes_for(:score,
                              cupping_id: cupping.id,
                              cupped_coffee_id: cupped_coffee.id,
                              grader_id: grader.id) }
    end
    context 'with valid auth token' do
      context 'with valid attributes' do
        before do
          post '/scores', params: valid_attributes, headers: auth_headers(host)
        end

        it 'returns the score' do
          expect(json['score']['notes']).to eq(valid_attributes[:score][:notes])
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end

      context 'with invalid attributes' do
        # FactoryGirl.attributes_for doesn't generate foreign keys
        it 'returns status code 422' do
          post scores_path, params: { score: attributes_for(:score) },
                            headers: auth_headers(host)
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          post scores_path, params: { score: attributes_for(:score) },
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

    context 'when cupping is closed' do
      before :each do
        cupping.update(open: false)
        post scores_path, params: valid_attributes,
                          headers: auth_headers(grader)
      end

      it_behaves_like 'restricted access when cupping is closed'
    end
  end

  describe 'PATCH /scores/:id' do
    let(:valid_attributes) { { score: { acidity: 3 } } }

    context 'with valid auth token' do
      context 'when the score exists' do
        before do
          patch "/scores/#{score_id}", params: valid_attributes,
                                       headers: auth_headers(grader)
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

    context 'when cupping is closed' do
      before :each do
        cupping.update(open: false)
        patch score_path(score), params: valid_attributes,
                                 headers: auth_headers(grader)
      end

      it_behaves_like 'restricted access when cupping is closed'
    end
  end

  describe 'DELETE /scores/:id' do
    context 'with valid auth token' do
      before { delete "/scores/#{score_id}", headers: auth_headers(grader) }
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'without valid auth token' do
      before { delete score_path(score) }

      it_behaves_like 'restricted access to scores'
    end

    context 'when cupping is closed' do
      before :each do
        cupping.update(open: false)
        delete score_path(score), headers: auth_headers(grader)
      end

      it_behaves_like 'restricted access when cupping is closed'
    end
  end

  describe 'POST /scores/submit_scores' do
    before :each do
      cupped_coffees = create_list(:cupped_coffee, 3, cupping_id: cupping.id)
      @new_scores = cupped_coffees.map do |cupped_coffee|
        attributes_for(:score,
                       grader_id: graders.last.id,
                       cupping_id: cupping.id,
                       cupped_coffee_id: cupped_coffee.id)
      end
    end
    context 'with valid auth token' do
      context 'with valid attributes for scores' do
        it 'returns status code 204' do
          post '/scores/submit_scores',
               params: { scores: @new_scores }, headers: auth_headers(graders.last)
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'with invalid attributes for scores' do
        before :each do
          # no grader_id
          invalid_score = attributes_for(:score,
                                         cupping_id: cupping.id,
                                         cupped_coffee_id: cupped_coffee.id)
          @new_scores << invalid_score

          post '/scores/submit_scores',
               params: { scores: @new_scores },
               headers: auth_headers(graders.last)
        end

        it 'returns status code 400' do
          expect(response).to have_http_status(400)
        end

        it 'returns an error message' do
          json = JSON.parse(response.body)
          expect(json['message']).not_to be_blank
        end
      end
    end

    context 'without valid auth token' do
      before { post submit_scores_scores_path }

      it_behaves_like 'restricted access to scores'
    end

    context 'when cupping is closed' do
      describe 'POST /scores/submit_scores' do
        before :each do
          cupped_coffees = create_list(:cupped_coffee, 3, cupping_id: cupping.id)
          @new_scores = cupped_coffees.map do |cupped_coffee|
            attributes_for(:score,
                           grader_id: graders.last.id,
                           cupping_id: cupping.id,
                           cupped_coffee_id: cupped_coffee.id)
          end
          cupping.update(open: false)

          post '/scores/submit_scores',
               params: { scores: @new_scores },
               headers: auth_headers(graders.last)
        end

        it_behaves_like 'restricted access when cupping is closed'
      end
    end
  end
end
