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
    json_response(@roaster, status: :created)
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

  # GET /roasters/search
  def search
    @results = search_results
    json_response(@results)
  end

  private

  def find_roaster
    @roaster = Roaster.find(params[:id])
  end

  def roaster_params
    params.require(:roaster).permit(:name, :location, :website)
  end

  def roasters_search
    Search.new('roasters', %w(name location))
  end

  def search_results
    return { roasters: [] } unless params[:term]
    roasters_search.call(params[:term], pagination_options)
  end
end
