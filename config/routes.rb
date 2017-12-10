Rails.application.routes.draw do
  resources :messages, except: [:index, :show]
  resources :users do
    member do
      delete 'takedown_target'
      post 'reinstate_player'
    end
  end
  root 'welcome#index'
  get '/takeover_disputes', to: 'users#takeover_disputes'
  get '/dispute_takeover', to: 'users#dispute_takeover'
  get '/update_pairings', to: 'users#update_pairings'
  get '/target_taken_down', to: 'users#target_taken_down'
  get 'takedown_target', to: 'users#takedown_target'
  get '/posts', to: 'users#posts'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
