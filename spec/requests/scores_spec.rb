require 'rails_helper'

RSpec.describe 'Scores API', type: :request do
  let(:coffee) { create(:coffee) }
  let(:roaster) { create(:roaster) }
  let(:cupping) { create(:cupping) }
  let(:cupped_coffee) { create(:cupped_coffee, cupping_id: cupping.id) }
  let(:grader) { create(:user) }
  let(:scores) { create_list(:score, 5, cupping_id: cupping.id, cupped_coffee_id: cupped_coffee.id, grader_id: grader.id ) }
  let(:score) { scores.first }
  let(:score_id) { score.id }

  describe 'GET /scores' do
    before do
      scores
      get scores_path
    end

    it 'returns all scores' do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /scores/:id' do
    context 'when the score exists' do
      before { get score_path(score) }

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
        get "/scores/#{score_id}"
      end

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Score/)
      end
    end
  end

  describe 'POST /scores' do
    let(:valid_attributes) { { roast_level: 4, aroma: 8, aftertaste: 7.25, acidity: 9, body: 7, uniformity: 6, balance: 9, clean_cup: 6.5, sweetness: 8, overall: 9, defects: 1, total_score: 72.75, notes: "pretty okay", cupping_id: cupping.id, cupped_coffee_id: cupped_coffee.id, grader_id: grader.id } }

    context 'with valid attributes' do
      before { post '/scores', params: valid_attributes }

      it 'returns the score' do
        expect(json['notes']).to eq(valid_attributes[:notes])
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'with invalid attributes' do
      it 'returns status code 422' do
        post scores_path, params: { score: { roast_level: nil }}
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        post scores_path, params: { score: { roast_level: nil }}
        expect(response.body)
          .to match(/Validation failed: Grader must exist, Cupped coffee must exist, Cupping must exist, Grader can't be blank, Cupping can't be blank, Cupped coffee can't be blank, Aroma can't be blank, Aftertaste can't be blank, Acidity can't be blank, Body can't be blank, Uniformity can't be blank, Balance can't be blank, Clean cup can't be blank, Sweetness can't be blank, Overall can't be blank, Defects can't be blank, Total score can't be blank/)
      end
    end
  end

  describe 'PATCH /scores/:id' do
    let(:valid_attributes) { { acidity: 3 } }

    context 'when the score exists' do
      before { patch "/scores/#{score_id}", params: valid_attributes }

      it 'updates the score' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  describe 'DELETE /scores/:id' do
    before { delete "/scores/#{score_id}" }
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end