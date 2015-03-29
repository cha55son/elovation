Rails.application.routes.draw do
  devise_for :players, controllers: {
    sessions: 'players/sessions'
  }

  resources :games do
    resources :results, only: [:create, :destroy, :new]
    resources :ratings, only: [:index]
    get :motion, on: :member
    get 'motion/clear', on: :member, to: 'games#motion_clear'
  end

  resources :players do
    resources :games, only: [:show], controller: 'player_games'
  end

  get '/dashboard' => 'dashboard#show', as: :dashboard
  root to: 'dashboard#show'
end
