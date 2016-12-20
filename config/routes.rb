Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :spaces do
    resources 'reservations', only: [:create]
  end
  root to: "home#index"

  get "search", to: 'search#index'

  get '/search/query', to: 'search#query'

  get '/users/:id', to: 'users#show'

  post '/ratings', to: 'ratings#create'

end
