class InvitesController < CuppingDependentController
  before_action :find_cupping, only: [:index, :create]
  before_action :find_invite, only: [:show, :update, :destroy]
  before_action :check_cupping_status, only: [:create, :update, :destroy]
  before_action :verify_host, only: [:create, :destroy]
  before_action :verify_grader_or_host, only: [:update]

  # Handle specific exception where an invalid grader_id can be passed into
  # POST#create (as grader association is optional)...
  rescue_from ActiveRecord::InvalidForeignKey do |e|
    json_response({ message: 'Validation failed: Grader id is invalid',
                    detail: e.message }, :unprocessable_entity)
  end

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
    InviteHandler.build.call(@invite, @cupping)
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
    params.require(:invite).permit(:cupping_id, :grader_id,
                                   :status, :grader_email)
  end

  def verify_grader_or_host
    json_response({ errors: ['Authorized users only'] }, :unauthorized) unless
      current_user_is_host? || current_user.id == @invite.grader_id
  end
end
