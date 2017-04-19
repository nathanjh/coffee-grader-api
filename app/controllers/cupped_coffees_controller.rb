class CuppedCoffeesController < CuppingDependentController
  before_action :find_cupping, only: [:index, :create]
  before_action :find_cupped_coffee, only: [:show, :update, :destroy]
  before_action :check_cupping_status, only: [:create, :update, :destroy]
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
    head :no_content
  end

  # DELETE /cuppings/:cupping_id/cupped_coffees/:id
  def destroy
    @cupped_coffee.destroy
    head :no_content
  end

  private

  def cupped_coffee_params
    params.require(:cupped_coffee).permit(:roast_date,
                                          :coffee_alias,
                                          :roaster_id,
                                          :coffee_id,
                                          :cupping_id)
  end
end
