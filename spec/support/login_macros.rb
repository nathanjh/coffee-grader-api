# Provides authentication support for controller/ request specs
module LoginMacros
  def login_user(user)
    auth_headers = user.create_new_auth_token
    request.headers.merge!(auth_headers)
  end
end
