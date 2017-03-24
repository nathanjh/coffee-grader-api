class CuppingRouteController < ApplicationController
  private

  def find_cupping
    @cupping =
      if params[:cupping_id]
        Cupping.find(params[:cupping_id])
      else
        Cupping.find(params[:id])
      end
    render nothing: true, status: :not_found unless @cupping.present?
  end

  def find_invite
    @invite = Invite.find(params[:id])
    render nothing: true, status: :not_found unless @invite.present?
  end

  def find_cupped_coffee
    @cupped_coffee = CuppedCoffee.find(params[:id])
    render nothing: true, status: :not_found unless @cupped_coffee.present?
  end
end
