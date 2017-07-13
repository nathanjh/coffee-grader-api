class RoastersController < CoffeeGraderApiController
  before_action :find_roaster, only: [:show, :update, :destroy]

  # GET /roasters
  def index
    @roasters = Roaster.all
    json_response(@roasters)
  end

  # GET /roasters/id
  def show
    json_response(@roaster)
  end

  # POST /roasters
  def create
    @roaster = Roaster.create!(roaster_params)
    json_response(@roaster, :created)
  end

  # PATCH /roasters/:id
  def update
    @roaster.update!(roaster_params)
    head :no_content
  end

  # DELETE /roasters/:id
  def destroy
    @roaster.destroy
    head :no_content
  end

  private

  def find_roaster
    @roaster = Roaster.find(params[:id])
  end

  def roaster_params
    params.permit(:name, :location, :website)
  end
end
