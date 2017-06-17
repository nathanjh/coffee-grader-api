class InvitesController < CuppingDependentController
  before_action :find_cupping, only: [:index, :create]
  before_action :find_invite, only: [:show, :update, :destroy]
  before_action :check_cupping_status, only: [:create, :update, :destroy]
  before_action :verify_host, only: [:create]

  # GET /cuppings/:cupping_id/invites
  def index
    @invites = @cupping.invites
    json_response(@invites)
  end

  # GET /cuppings/:cupping_id/invites/:id
  def show
    json_response(@invite)
  end

  # POST /cuppings/:cupping_id/invites
  def create
    @invite = @cupping.invites.create!(invite_params)
    json_response(@invite, :created)
  end

  # PATCH /cuppings/:cupping_id/invites/:id
  def update
    @invite.update!(invite_params)
    head :no_content
  end

  # DELETE /cuppings/:cupping_id/invites/:id
  def destroy
    @invite.destroy
    head :no_content
  end

  private

  def invite_params
    params.require(:invite).permit(:cupping_id, :grader_id, :status)
  end
end
