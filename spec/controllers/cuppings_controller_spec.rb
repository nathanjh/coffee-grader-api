require 'rails_helper'

RSpec.describe CuppingsController, type: :controller do

  let(:user) { create(:user) }
  let!(:cuppings) { create_list(:cupping, 5) }
  let(:cupping) { cuppings.first }
  let(:cupping_id) { cupping.id }

  describe 'GET #index' do
    it 'collects all cuppings into @cuppings' do
      get :index, format: :json
      expect(assigns(:cuppings)).to eq cuppings
    end
  end

  describe 'GET #show' do
    let(:requested_cupping) { create(:cupping) }

    it 'assigns the requested cupping as @cupping' do
      get :show, params: { id: requested_cupping }
      expect(assigns(:cupping)).to eq requested_cupping
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new cupping in the database' do
        expect { post :create, params: attributes_for(:cupping, host_id: user.id) }
          .to change(Cupping, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it "doesn't save the new cupping in the database" do
        expect { post :create, params: { cupping: { name: nil } } }
          .not_to change(Cupping, :count)
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @cupping = create(:cupping,
                       host_id: user.id,
                       location: 'San Francisco, CA',
                       cup_date: Time.now,
                       cups_per_sample: 3
                       )
    end

    context 'with valid attributes' do
      it 'locates the requested cupping' do
        patch :update, params: { id: @cupping, cupping: attributes_for(:cupping) }
        expect(assigns(:cupping)).to eq(@cupping)
      end

      it "updates cupping's attributes" do
        patch :update,
              params: { id: @cupping,
                        location: 'Santa Clara' }
        @cupping.reload
        expect(@cupping.location).to eq('Santa Clara')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the cupping record from the database' do
      cupping = create(:cupping)
      expect { delete :destroy, params: { id: cupping.id } }
        .to change(Cupping, :count).by(-1)
    end
  end
end
