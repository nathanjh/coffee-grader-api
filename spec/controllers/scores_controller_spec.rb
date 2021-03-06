require 'rails_helper'

RSpec.describe ScoresController, type: :controller do
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

  let(:valid_attributes) do
    { score: attributes_for(:score,
                            cupping_id: cupping.id,
                            cupped_coffee_id: cupped_coffee.id,
                            grader_id: graders.first.id) }
  end

  before { login_user(host) }

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
        expect { post :create, params: { score: attributes_for(:score) } }
          .not_to change(Score, :count)
      end
    end

    context 'when cupping is closed' do
      it "doesn't save the new score in the database" do
        cupping.update(open: false)

        expect do
          post :create, params: valid_attributes, format: :json
        end
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
                                 score: { aftertaste: 8 } }, format: :json
        score.reload
        expect(score.aftertaste).to eq(8)
      end
    end

    context 'when cupping is closed' do
      it "doesn't update the score's attrbutes" do
        cupping.update(open: false)
        patch :update, params: { id: score,
                                 aftertaste: 2 }, format: :json
        score.reload
        expect(score.aftertaste).not_to eq(2)
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

    context 'when cupping is closed' do
      it "doesn't delete the score from the database" do
        scores
        cupping.update(open: false)
        expect do
          delete :destroy, params: { id: score },
                           format: :json
        end
          .not_to change(Score, :count)
      end
    end
  end

  describe 'POST #submit_scores' do
    before :each do
      cupped_coffees = create_list(:cupped_coffee, 3, cupping_id: cupping.id)
      @new_scores = cupped_coffees.map do |cupped_coffee|
        attributes_for(:score,
                       grader_id: graders.last.id,
                       cupping_id: cupping.id,
                       cupped_coffee_id: cupped_coffee.id)
      end
    end
    context 'with valid attributes' do
      it 'saves a batch of scores to the database' do
        expect do
          post :submit_scores, params: { scores: @new_scores }, format: :json
        end
          .to change(Score, :count).by(3)
      end
    end

    context 'with invalid attributes for any score in the collection' do
      it "doesn't save any scores in the database" do
        # no grader_id
        invalid_score = attributes_for(:score,
                                       cupping_id: cupping.id,
                                       cupped_coffee_id: cupped_coffee.id)
        @new_scores << invalid_score
        expect do
          post :submit_scores, params: { scores: @new_scores }, format: :json
        end
          .not_to change(Score, :count)
      end
    end

    context 'when cupping is closed' do
      it "doesn't save any scores in the database" do
        cupping.update(open: false)

        expect do
          post :submit_scores, params: { scores: @new_scores }, format: :json
        end
          .not_to change(Score, :count)
      end
    end
  end
end
