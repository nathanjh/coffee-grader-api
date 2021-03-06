class CuppingsController < CuppingDependentController
  before_action :find_cupping, only: [:show, :update, :destroy]
  before_action :verify_host, only: [:update, :destroy]

  # GET /cuppings
  def index
    @cuppings = Cupping.all
    json_response(@cuppings)
  end

  # GET /cuppings/id
  def show
    json_response(@cupping)
  end

  # POST /cuppings
  def create
    @cupping = Cupping.create!(cupping_params)
    json_response(@cupping, status: :created)
  end

  # PATCH /cuppings/:id
  def update
    @cupping.update!(cupping_params)
    head :no_content
  end

  # DELETE /cuppings/:id
  def destroy
    @cupping.destroy
    head :no_content
  end

  private

  def cupping_params
    params.require(:cupping)
          .permit(:location, :cup_date, :cups_per_sample, :host_id)
  end
end
