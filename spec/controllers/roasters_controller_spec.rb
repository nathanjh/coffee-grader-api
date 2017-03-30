require 'rails_helper'

RSpec.describe RoastersController, type: :controller do
  before { login_user(create(:user)) }

  describe 'GET #index' do
    it 'collects all roasters into @roasters' do
      roasters = [create(:roaster), create(:roaster, name: 'Cup A Joe')]
      get :index, format: :json
      expect(assigns(:roasters)).to eq roasters
    end
  end

  describe 'GET #show' do
    let(:requested_roaster) { create(:roaster) }

    it 'assigns the requested roaster as @roaster' do
      get :show, params: { id: requested_roaster }
      expect(assigns(:roaster)).to eq requested_roaster
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new roaster in the database' do
        expect { post :create, params: attributes_for(:roaster) }
          .to change(Roaster, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it "doesn't save the new roaster in the database" do
        expect { post :create, params: { roaster: { name: nil } } }
          .not_to change(Roaster, :count)
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @roaster = create(:roaster,
                       name: 'Some Roaster',
                       location: 'Arcadia, CA',
                       website: 'www.someroaster.com')
    end

    context 'with valid attributes' do
      it 'locates the requested roaster' do
        patch :update, params: { id: @roaster, roaster: attributes_for(:roaster) }
        expect(assigns(:roaster)).to eq(@roaster)
      end

      it "updates roaster's attributes" do
        patch :update,
              params: { id: @roaster,
                        location: 'El Salvador' }
        @roaster.reload
        expect(@roaster.location).to eq('El Salvador')
      end
    end

    context 'with invalid attributes' do
      before :each do
        Roaster.create(name: 'Some Roaster',
                       location: 'Arcadia, CA',
                       website: 'www.someroaster.com')
      end

      it "doesn't change the roaster's attributes" do
        # record is invalid: uniqueness of name scoped to location
        patch :update, params: { id: @roaster, name: 'Cup A Joe' }
        expect(@roaster.name).not_to eq('Cup A Joe')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the roaster record from the database' do
      roaster = create(:roaster)
      expect { delete :destroy, params: { id: roaster.id } }
        .to change(Roaster, :count).by(-1)
    end
  end
end
