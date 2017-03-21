require 'rails_helper'

RSpec.describe CuppedCoffeesController, type: :controller do
  let(:cupping) { create(:cupping) }
  let(:coffee) { create(:coffee) }
  let(:roaster) { create(:roaster) }
  let(:cupped_coffees) do
    [CuppedCoffee.create!(roast_date: DateTime.now - 1,
                          coffee_alias: Faker::Lorem.characters(7),
                          cupping_id: cupping.id,
                          roaster_id: roaster.id,
                          coffee_id: Coffee.create!(name: 'Aragon',
                                                    origin: 'Colombia',
                                                    producer: 'Beneficio Bella Vista').id),
     CuppedCoffee.create!(roast_date: DateTime.now - 1,
                          coffee_alias: Faker::Lorem.characters(7),
                          cupping_id: cupping.id,
                          roaster_id: roaster.id,
                          coffee_id: coffee.id)]
  end
  let(:cupped_coffee) { cupped_coffees.first }

  describe 'GET #index' do
    it 'collects all cuppeded coffees into @cupped_coffees' do
      get :index, params: { cupping_id: cupping.id }, format: :json
      expect(assigns(:cupped_coffees)).to eq cupped_coffees
    end
  end

  describe 'GET #show' do
    it 'assigns the requested cupped_coffee as @cupped_coffee' do
      get :show, params: { id: cupped_coffee, cupping_id: cupping.id },
                 format: :json
      expect(assigns(:cupped_coffee)).to eq cupped_coffee
    end
  end

  describe 'POST #create' do
    context 'with vaild attributes' do
      it 'saves a new cupped_coffee in the database' do
        # post :create, params: {
        #   cupped_coffee: { roast_date: DateTime.now - 1,
        #                    coffee_alias: 'Sample A',
        #                    coffee_id: coffee.id,
        #                    roaster_id: roaster.id },
        #   cupping_id: cupping.id
        # }, format: :json
      #
        expect do
          post :create, params: {
            cupped_coffee: { roast_date: DateTime.now - 1,
                             coffee_alias: 'Sample A',
                             coffee_id: coffee.id,
                             roaster_id: roaster.id },
            cupping_id: cupping.id
          }, format: :json
        end
          .to change(CuppedCoffee, :count).by(1)
      end
      # end
    end

    context 'with invalid attributes' do
      it "doesn't save the new coffee in the database" do
        expect do
          post :create, params: {
            cupped_coffee: attributes_for(:cupped_coffee),
            cupping_id: cupping.id
          }, format: :json
        end
          .not_to change(CuppedCoffee, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with vaild attributes' do
      it 'locates the requested cupped_coffee' do
        patch :update, params: { id: cupped_coffee,
                                 cupping_id: cupping.id,
                                 cupped_coffee: attributes_for(:cupped_coffee) },
                       format: :json
        expect(assigns(:cupped_coffee)).to eq(cupped_coffee)
      end

      it "updates the cupped_coffee's attributes" do
        patch :update, params: { id: cupped_coffee,
                                 cupping_id: cupping.id,
                                 cupped_coffee: { coffee_alias: 'Uptown!' } },
                       format: :json
        cupped_coffee.reload
        expect(cupped_coffee.coffee_alias).to eq('Uptown!')
      end
    end

    context 'with invalid attributes' do
      it "doesn't change the cupped_coffee's attributes" do
        # let's update an existing record's coffee_alias to test cupping-scoped
        # uniqueness vailidity
        patch :update, params: { id: cupped_coffee,
                                 cupping_id: cupping.id,
                                 cupped_coffee: { coffee_alias: 'Once-a-Cupping' } },
                       format: :json
        # record is invalid when duplicate alias is used in the same cupping
        cupped_coffee2 = cupped_coffees.last
        patch :update, params: { id: cupped_coffee2,
                                 cupping_id: cupping.id,
                                 cupped_coffee: { coffee_alias: 'Once-a-Cupping' } },
                       format: :json
        expect(cupped_coffee2.coffee_alias).not_to eq('Once-a-Cupping')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'locates the requested cupped_coffee' do
      delete :destroy, params: { id: cupped_coffee,
                                 cupping_id: cupping.id },
                       format: :json
      expect(assigns(:cupped_coffee)).to eq(cupped_coffee)
    end

    it 'deletes the coffee record from the database' do
      cupped_coffees
      expect do
        delete :destroy, params: { id: cupped_coffee,
                                   cupping_id: cupping.id },
                         format: :json
      end
        .to change(CuppedCoffee, :count).by(-1)
    end
  end
end
