class UsersController < CoffeeGraderApiController
  before_action :authenticate_user!
  before_action :find_user, only: [:show]
  # GET /users/id
  def show
    json_response(@user, serializer: UserShowSerializer)
  end

  # GET /users/search
  def search
    @results = search_results
    json_response(@results)
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def users_search
    Search.new('users', %w(username email))
  end

  def search_results
    return { users: [] } unless params[:term]
    users_search.call(params[:term], pagination_options)
  end
end
