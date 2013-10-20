OnePlusOne::Application.routes.draw do
  resources :teams, only: [:index, :create, :destroy] do
    member do
      get 'people'
      post 'add'
      post 'remove'
    end
  end

  resources :people, only: [:index, :create, :destroy]

  root controller: 'main', action: 'index'
end
