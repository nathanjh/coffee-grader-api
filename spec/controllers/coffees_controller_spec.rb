require 'rails_helper'
# thinking about including controller tests for internal controller logic testing
# TODO: finish these, or delete 'em all together if deemed unecessarry
RSpec.describe 'CoffeesController', type: :controller do
  describe 'GET #index' do
    it 'collects all coffees into @coffees' do
      coffees = create_list(:coffee, 5)
      get :index, format: :json
      expect(assigns(:coffees)).to eq coffees
    end
  end

  describe 'GET #show' do
    let(:requested_coffee) { create(:coffee) }

    it 'returns an error message when coffee does not exist' do
      get :show, params: { id: 1_000_000_000 }, format: :json
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).to eq 'Coffee does not exist'
      expect(response).to have_http_status(404)
    end
  end

  describe 'POST #create' do

  end

  describe 'PATCH #update' do

  end

  describe 'DELETE #destroy' do

  end
end
