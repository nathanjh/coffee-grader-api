class CoffeesController < CoffeeGraderApiController
  before_action :find_coffee, only: [:show, :update, :destroy]
  # GET '/coffees'
  def index
    @coffees = Coffee.all
    json_response(@coffees)
  end

  # GET '/coffees/:id'
  def show
    json_response(@coffee)
  end

  # POST '/coffees'
  def create
    @coffee = Coffee.create!(coffee_params)
    json_response(@coffee, status: :created)
  end

  # PATCH '/coffees/:id'
  def update
    # the bang is super important to trigger the ExceptionHandler response
    @coffee.update!(coffee_params)
    head :no_content
  end

  # DELETE '/coffees/:id'
  def destroy
    @coffee.destroy
    head :no_content
  end

  # GET '/coffees/search'
  def search
    @results = search_results
    json_response(@results)
  end

  private

  def find_coffee
    @coffee = Coffee.find(params[:id])
  end

  def coffee_params
    params.require(:coffee).permit(:name, :origin, :producer)
  end

  def coffees_search
    Search.new('coffees', %w(name producer origin))
  end

  def search_results
    return { coffees: [] } unless params[:term]
    coffees_search.call(params[:term], pagination_options)
  end
end
