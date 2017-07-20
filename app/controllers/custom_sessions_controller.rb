# To customize devise token auth sessions rendering behavior
class CustomSessionsController < DeviseTokenAuth::SessionsController
  def render_create_success
    json_response(@resource)
  end
end
