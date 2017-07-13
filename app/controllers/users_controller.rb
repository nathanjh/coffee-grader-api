class UsersController < CoffeeGraderApiController
  before_action :authenticate_user!
  before_action :find_user, only: [:show]
  # GET /users/id
  def show
    json_response(@user)
  end

  # GET /users/search
  def search
    @results =
      if params[:term]
        users_search.call(params[:term], pagination_options)
      else
        []
      end
    json_response(@results)
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def users_search
    Search.new('users', %w(username email))
  end
end
