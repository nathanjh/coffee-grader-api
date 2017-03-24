require 'rails_helper'

RSpec.describe 'Scores API', type: :request do
  let(:coffee) { create(:coffee) }
  let(:roaster) { create(:roaster) }
  let(:cupping) { create(:cupping) }
  let(:cupped_coffee) { create(:cupped_coffee, cupping_id: cupping.id) }
  let(:grader) { create(:user) }
  let(:scores) { create_list(:score, 5, cupping_id: cupping.id, cupped_coffee_id: cupped_coffee.id, grader_id: grader.id ) }
  let(:score) { scores.first }

  describe 'GET /scores' do
    before do
      scores
      get scores_path
    end

    it 'returns all scores' do
      p "*" * 50
      p json
      p "*" * 50
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

  # describe 'POST /scores' do
  #   let(:valid_attributes) { { name: 'Cafe Elfie', location: 'Millbrae, CA', website: 'www.cafeelfie.com' } }

  #   context 'with valid attributes' do
  #     before { post '/roasters', params: valid_attributes }

  #     it 'returns the score' do
  #       expect(json['location']).to eq(valid_attributes[:location])
  #     end

  #     it 'returns status code 201' do
  #       expect(response).to have_http_status(201)
  #     end
  #   end

  #   context 'with invalid attributes' do
  #     it 'returns status code 422' do
  #       post scores_path, params: { score: { name: nil }}
  #       expect(response).to have_http_status(422)
  #     end

  #     it 'returns a validation failure message' do
  #       post scores_path, params: { score: { name: nil }}
  #       expect(response.body)
  #         .to match(/Validation failed: Name can't be blank/)
  #     end
  #   end
  # end

  # describe 'PATCH /scores/:id' do
  #   let(:valid_attributes) { { location: 'Carpinteria, CA' } }

  #   context 'when the score exists' do
  #     before { patch "/scores/#{score_id}", params: valid_attributes }

  #     it 'updates the score' do
  #       expect(response.body).to be_empty
  #     end

  #     it 'returns status code 204' do
  #       expect(response).to have_http_status(204)
  #     end
  #   end
  # end

  # describe 'DELETE /scores/:id' do
  #   before { delete "/scores/#{score_id}" }
  #   it 'returns status code 204' do
  #     expect(response).to have_http_status(204)
  #   end
  # end
end