require 'rails_helper'

RSpec.describe ScoresController, type: :controller do
  let(:cupping) { create(:cupping) }
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

  let(:valid_attributes) do
    attributes_for(:score,
                   cupping_id: cupping.id,
                   cupped_coffee_id: cupped_coffee.id,
                   grader_id: graders.first.id)
  end

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
    context 'with valid attributes' do
      it 'saves an score in the database' do
        expect { post :create, params: valid_attributes }
          .to change(Score, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      # FactoryGirl.attributes_for doesn't generate foreign keys
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
                                 aftertaste: 8 }, format: :json
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
