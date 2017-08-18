class UsersController < CoffeeGraderApiController
  before_action :authenticate_user!
  before_action :find_user, only: [:show]
  # GET /users?uid=
  def index
    @user = User.find_by_uid!(params[:uid]) if params[:uid]
    validate_uid_response
  end

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

  def validate_uid_response
    if @user && @user.uid == request.headers[:uid]
      json_response(@user)
    else
      json_response({ errors: ['Uid parameter invalid or blank'] },
                    status: :bad_request)
    end
  end

  def users_search
    Search.new('users', %w(username email))
  end

  def search_results
    return { users: [] } unless params[:term]
    users_search.call(params[:term], pagination_options)
  end
end
