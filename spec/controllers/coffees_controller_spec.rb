require 'rails_helper'

RSpec.describe CoffeesController, type: :controller do
  describe 'GET #index' do
    it 'collects all coffees into @coffees' do
      # coffees = create_list(:coffee, 5)
      coffees = [create(:coffee), create(:coffee, name: 'Hunapu')]
      get :index, format: :json
      expect(assigns(:coffees)).to eq coffees
    end
  end

  before { login_user(create(:user)) }

  describe 'GET #show' do
    let(:requested_coffee) { create(:coffee) }

    it 'assigns the requested coffee as @coffee' do
      get :show, params: { id: requested_coffee }
      expect(assigns(:coffee)).to eq requested_coffee
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do

      it 'saves a new coffee in the database' do
        expect { post :create, params: attributes_for(:coffee) }
          .to change(Coffee, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it "doesn't save the new coffee in the database" do
        expect { post :create, params: { coffee: { name: nil } } }
          .not_to change(Coffee, :count)
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @coffee = create(:coffee,
                       name: 'Aragon',
                       origin: 'Guatemala',
                       producer: 'Beneficio Bella Vista')
    end

    context 'with valid attributes' do
      it 'locates the requested coffee' do
        patch :update, params: { id: @coffee, coffee: attributes_for(:coffee) }
        expect(assigns(:coffee)).to eq(@coffee)
      end

      it "updates coffee's attributes" do
        patch :update,
              params: { id: @coffee,
                        origin: 'El Salvador' }
        @coffee.reload
        expect(@coffee.origin).to eq('El Salvador')
      end
    end

    context 'with invalid attributes' do
      before :each do
        Coffee.create(name: 'Hunapu',
                      origin: 'Guatemala',
                      producer: 'Beneficio Bella Vista')
      end

      it "doesn't change the coffee's attributes" do
        # record is invalid: uniqueness of name scoped to origin and producer
        patch :update, params: { id: @coffee, name: 'Hunapu' }
        expect(@coffee.name).not_to eq('Hunapu')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the coffee record from the database' do
      coffee = create(:coffee)
      expect { delete :destroy, params: { id: coffee.id } }
        .to change(Coffee, :count).by(-1)
    end
  end
end
