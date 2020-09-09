Rails.application.routes.draw do
  root to: 'pages#home'
  resources :info_preliminaires, only: [:new, :create]
  get 'error', to: "info_preliminaires#error", as: :error
  resources :documents, only: [:new, :create, :show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
