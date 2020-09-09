Rails.application.routes.draw do
  root to: 'pages#home'
  resources :profiles, only: [:new, :create]
  get 'error', to: "profiles#error", as: :error
  resources :documents, only: [:new, :create, :show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/download', to: 'things#show'
end
