# to ensure that username attribute is set when sign-in with omniauth
class CustomOmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  protected

  def assign_provider_attrs(user, auth_hash)
    user.assign_attributes(nickname: auth_hash['info']['nickname'] || auth_hash['info']['name'],
                           name:     auth_hash['info']['name'],
                           image:    auth_hash['info']['image'],
                           email:    auth_hash['info']['email'])
  end
end
