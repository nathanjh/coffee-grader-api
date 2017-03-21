Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: :show, defaults: { format: :json }
  resources :roasters
  resources :coffees
  resources :cuppings
  resources :cuppings do
    resources :invites
    resources :cupped_coffees
  end
end
