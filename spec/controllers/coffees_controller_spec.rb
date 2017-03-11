require 'rails_helper'
# thinking about including controller tests for internal controller logic testing
# TODO: finish these, or delete 'em all together if deemed unecessarry
RSpec.describe CoffeesController, type: :controller do
  describe 'GET #index' do
    it 'collects all coffees into @coffees' do
      coffees = create_list(:coffee, 5)
      get :index, format: :json
      expect(assigns(:coffees)).to eq coffees
    end
  end

  describe 'GET #show' do
    let(:requested_coffee) { create(:coffee) }

    it 'assigns the requested coffee as @coffee' do
      get :show, id: requested_coffee
      expect(assigns(:coffee)).to eq requested_coffee
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new coffee in the database' do
        expect { post :create, coffee: attributes_for(:coffee) }
          .to change(Coffee, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it "doesn't save the new coffee in the database" do
        expect { post :create, coffee: { name: nil } }
          .not_to change(Coffee, :count)
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      # just in case Faker::Coffee PR ever gets merged!
      @coffee = create(:coffee,
                       name: 'Aragon',
                       origin: 'Guatemala',
                       farm: 'Beneficio Bella Vista')
    end

    context 'with valid attributes' do
      it 'locates the requested coffee' do
        patch :update, id: @coffee, coffee: attributes_for(:coffee)
        exepct(assigns(:coffee)).to eq(@coffee)
      end

      it "updates coffee's attributes" do
        patch :update,
              id: @coffee,
              coffee: attributes_for(:coffee, origin: 'El Salvador')
        @coffee.reload
        expect(@coffee.origin).to eq('El Salvador')
      end
    end
    context 'with invalid attributes' do
      before :each do
        Coffee.create(name: 'Hunapu',
                      origin: 'Guatemala',
                      farm: 'Beneficio Bella Vista')
      end

      it "doesn't change the coffee's attributes" do
        # record is invalid: uniqueness of name scoped to origin and farm
        patch :update, id: @coffee, coffee: { name: Hunapu }
        expect(@coffee.name).not_to eq('Hunapu')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the coffee record from the database' do
      coffee = create(:coffee)
      expect { delete :destroy, id: coffee.id }
        .to change(Coffee, :count).by(-1)
    end
  end
end
