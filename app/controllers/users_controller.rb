class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: [:show]
  # GET /users/id
  def show
    render json: @user
  end

  private

  def find_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User does not exist' }, status: :not_found
  end
end
