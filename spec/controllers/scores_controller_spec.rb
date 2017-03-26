require 'rails_helper'

RSpec.describe ScoresController, type: :controller do
  let(:coffee) { create(:coffee) }
  let(:roaster) { create(:roaster) }
  let(:cupping) { create(:cupping) }
  let(:cupped_coffee) { create(:cupped_coffee, cupping_id: cupping.id) }
  let(:grader) { create(:user) }
  let(:scores) { create_list(:score, 5, cupping_id: cupping.id, cupped_coffee_id: cupped_coffee.id, grader_id: grader.id ) }
  let(:score) { scores.first }
  let(:score_id) { score.id }

  let(:valid_attributes) { { roast_level: 4,
                             aroma: 8,
                             aftertaste: 7.25,
                             acidity: 9,
                             body: 7,
                             uniformity: 6,
                             balance: 9,
                             clean_cup: 6.5,
                             sweetness: 8,
                             overall: 9,
                             defects: 1,
                             total_score: 72.75,
                             notes: "pretty okay",
                             cupping_id: cupping.id,
                             cupped_coffee_id: cupped_coffee.id,
                             grader_id: grader.id } }

  describe 'GET #index' do
    it 'returns all scores as @scores' do
      scores
      get :index, format: :json
      expect(assigns(:scores)).to eq scores
    end
  end

  describe 'GET #show' do
    it 'assigns the requested score as @score' do
      get :show, params: { id: score.id }
      expect(assigns(:score)).to eq score
    end
  end

  describe 'POST #create' do
    context 'with vaild attributes' do
      it 'saves an score in the database' do
        expect { post :create, params: attributes_for(:score, grader_id: grader.id, cupping_id: cupping.id, cupped_coffee_id: cupped_coffee.id) }
          .to change(Score, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it "doesn't save the new score in the database" do
        expect { post :create, params: attributes_for(:score) }
          .not_to change(Score, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'locates the requested score' do
        patch :update, params: { id: score,
                                 score: attributes_for(:score) }, format: :json
        expect(assigns(:score)).to eq(score)
      end

      it "updates the score's attributes" do
        patch :update, params: { id: score,
                                 aftertaste: 8  }, format: :json
        score.reload
        expect(score.aftertaste).to eq(8)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'locates the score' do
      delete :destroy, params: { id: score },
                       format: :json
      expect(assigns(:score)).to eq(score)
    end

    it 'deletes the score from the database' do
      scores
      expect do
        delete :destroy, params: { id: score },
                         format: :json
      end
        .to change(Score, :count).by(-1)
    end
  end
end
