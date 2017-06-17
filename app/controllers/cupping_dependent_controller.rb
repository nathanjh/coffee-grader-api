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
    @cupping ||=
      if params[:cupping_id]
        Cupping.find(params[:cupping_id])
      elsif @score
        Cupping.find(@score.cupping_id)
      end
    error_message = 'Cupping is closed and cannot receive any new invites, coffee samples, or scores.'
    json_response({ message: error_message }, :bad_request) if
      @cupping && !@cupping.open
  end

  def verify_host
    json_response({ errors: ['Authorized users only'] }, :unauthorized) unless
      current_user_is_host?
  end

  def current_user_is_host?
    current_user && current_user.id == @cupping.host_id
  end
end
