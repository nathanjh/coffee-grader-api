Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'custom_registrations',
    sessions: 'custom_sessions'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # To use the Sidekiq Web UI in development env only!
  if Rails.env == 'development'
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :users, only: :show, defaults: { format: :json } do
    get 'search', on: :collection
  end
  resources :roasters, defaults: { format: :json } do
    get 'search', on: :collection
  end
  resources :coffees, defaults: { format: :json } do
    get 'search', on: :collection
  end
  resources :cuppings
  resources :cuppings do
    resources :invites
    resources :cupped_coffees
  end
  resources :scores do
    post 'submit_scores', on: :collection
  end
end
