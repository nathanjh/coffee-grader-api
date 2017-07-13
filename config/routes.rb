Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'custom_registrations'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: :show, defaults: { format: :json } do
    get 'search', on: :collection
  end
  resources :roasters
  resources :coffees
  resources :cuppings
  resources :cuppings do
    resources :invites
    resources :cupped_coffees
  end
  resources :scores do
    post 'submit_scores', on: :collection
  end
end
