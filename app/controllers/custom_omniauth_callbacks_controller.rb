# to ensure that username attribute is set when sign-in with omniauth
class CustomOmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  protected

  # Workaround to handle case where no username/nickname param comes back from
  # oauth provider (username attribute is required by user model)
  def assign_provider_attrs(user, auth_hash)
    user.assign_attributes(nickname: auth_hash['info']['nickname'] || auth_hash['info']['name'],
                           name:     auth_hash['info']['name'],
                           image:    auth_hash['info']['image'],
                           email:    auth_hash['info']['email'])
  end

  def render_data_or_redirect(message, data, user_data = {})
    # We handle inAppBrowser and newWindow the same, but it is nice
    # to support values in case people need custom implementations for each case
    # (For example, nbrustein does not allow new users to be created if logging
    # in with an inAppBrowser)
    #
    # See app/views/devise_token_auth/omniauth_external_window.html.erb to
    # understand why we can handle these both the same.  The view is setup to
    # handle both cases at the same time.
    if %w(inAppBrowser newWindow).include?(omniauth_window_type)
      render_data(message, user_data.merge(data))

    elsif auth_origin_url
      # default to same-window implementation, which forwards back to auth_origin_url

      # build and redirect to destination url
      redirect_to redirect_url(auth_origin_url, data)
    else

      # there SHOULD always be an auth_origin_url, but if someone does something
      # silly like coming straight to this url or refreshing the page at the
      # wrong time, there may not be one.
      # In that case, just render in plain text the error message if there is
      # one or otherwise a generic message.
      fallback_render data[:error] || 'An error occurred'
    end
  end

  def generate_hashmode_url(url, params = {})
    uri = URI(url)

    res = "#{uri.scheme}://#{uri.host}"
    res += ":#{uri.port}" if uri.port && uri.port != 80 && uri.port != 443
    res += "#{uri.path}#/" if uri.path
    query = [uri.query, params.to_query].reject(&:blank?).join('&')
    res += "?#{query}"
    res += "##{uri.fragment}" if uri.fragment

    res
  end

  def redirect_url(url, data)
    # hashmode option passed in as a query param to handle vue-router style
    # hash url
    if omniauth_params['hashmode'] == 'true'
      generate_hashmode_url(url, data.merge(blank: true))
    else
      DeviseTokenAuth::Url.generate(url, data.merge(blank: true))
    end
  end
end
