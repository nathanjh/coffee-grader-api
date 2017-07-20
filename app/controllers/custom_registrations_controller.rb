# To provide functionality for invite token matching upon new user creation
class CustomRegistrationsController < DeviseTokenAuth::RegistrationsController
  def create
    super do |resource|
      MatchInviteToken.build.call(resource)
    end
  end

  def render_create_success
    json_response(@resource)
  end
end
