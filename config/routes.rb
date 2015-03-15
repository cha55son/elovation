Elovation::Application.routes.draw do
  devise_for :players, controllers: {
    sessions: 'players/sessions'
  }

  resources :games do
    resources :results, only: [:create, :destroy, :new]
    resources :ratings, only: [:index]
    get :motion, on: :member
  end

  resources :players do
    resources :games, only: [:show], controller: 'player_games'
  end

  get '/dashboard' => 'dashboard#show', as: :dashboard
  root to: 'dashboard#show'
end
