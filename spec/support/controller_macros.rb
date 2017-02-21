# Provides support for controller tests to work with devise_token_auth gem
module ControllerMacros
  def login_user
    before(:each) do
      user = create(:user)
      auth_headers = user.create_new_auth_token
      request.headers.merge!(auth_headers)
    end
  end
end
