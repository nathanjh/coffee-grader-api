class RoastersController < ApplicationController
  before_action :find_roaster, only: [:show, :patch, :delete]


  # GET /roasters/id
  def show
    json_response(@roaster)
  end




  private

  def find_roaster
    @roaster = Roaster.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Roaster does not exist' }, status: :not_found
  end

  def roaster_params
    params.require(:roaster).permit(:name, :location, :website)
  end

end

