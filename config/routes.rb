Rails.application.routes.draw do
  root to: 'pages#home'
  resources :infos, only: [:new, :create] do
    resources :documents, only: [:new, :create, :show]
    resources :jobs, only: [:new, :create, :destroy]
  end
  get 'error', to: "infos#error", as: :error
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
