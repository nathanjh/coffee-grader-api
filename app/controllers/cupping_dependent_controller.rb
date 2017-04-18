# Parent controller for all controllers dependent on cuppings
class CuppingDependentController < CoffeeGraderApiController
  private

  def find_cupping
    @cupping =
      if params[:cupping_id]
        Cupping.find(params[:cupping_id])
      else
        Cupping.find(params[:id])
      end
    head :not_found unless @cupping.present?
  end

  def find_invite
    @invite = Invite.find(params[:id])
    head :not_found unless @invite.present?
  end

  def find_cupped_coffee
    @cupped_coffee = CuppedCoffee.find(params[:id])
    head :not_found unless @cupped_coffee.present?
  end

  def find_score
    @score = Score.find(params[:id])
    head :not_found unless @score.present?
  end

  def check_cupping_status
    # add logic to find a cupping by params (otherwise, locate by requested
    # resource's cupping_id), then check open status and render
    # an appropriate response if @cupping.open == false
    # if a rescource is passed in, find cupping by resource.cupping_id, otherwise,
    # find cupping using cupping_id in params
    # if resource
    #   cupping = Cupping.find(resource.cupping_id)
    # elsif params[:cupping_id]
    #   cupping = Cupping.find(params[:cupping_id])
    # end
    # render json: { error: 'Cupping is closed. Request cannot be completed.' },
    #        status: :bad_request unless cupping.open
    @cupping ||=
      if params[:cupping_id]
        Cupping.find(params[:cupping_id])
      elsif @score
        Cupping.find(@score.cupping_id)
      end

    json_response({ message: 'Cupping is closed.' }, :bad_request) if
      @cupping && !@cupping.open
  end
end
