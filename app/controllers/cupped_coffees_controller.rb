class CuppedCoffeesController < ApplicationController
  before_action :load_cupping
  before_action :load_cupped_coffee, only: [:show, :update, :destroy]
  # GET /cuppings/:cupping_id/cupped_coffees/
  def index
    @cupped_coffees = @cupping.cupped_coffees
    json_response(@cupped_coffees)
  end

  # GET /cuppings/:cupping_id/cupped_coffees/:id
  def show
    json_response(@cupped_coffee)
  end

  # POST /cuppings/:cupping_id/cupped_coffees/
  def create
    @cupped_coffee = @cupping.cupped_coffees.create!(cupped_coffee_params)
    json_response(@cupped_coffee, :created)
  end

  # PATCH /cuppings/:cupping_id/cupped_coffees/:id
  def update
    @cupped_coffee.update!(cupped_coffee_params)
  end

  # DELETE /cuppings/:cupping_id/cupped_coffees/:id
  def destroy
    @cupped_coffee.destroy
  end

  private

  # didn't want to name this 'find_cupping', as it's already defined in cuppings controller
  def load_cupping
    @cupping = Cupping.find(params[:cupping_id])
  end

  def load_cupped_coffee
    @cupped_coffee = CuppedCoffee.find(params[:id])
  end

  def cupped_coffee_params
    params.require(:cupped_coffee).permit(:roast_date,
                                          :coffee_alias,
                                          :roaster_id,
                                          :coffee_id,
                                          :cupping_id)
  end
end
