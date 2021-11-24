Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'home_page#index'

  resources :sessions, only: [:new, :create, :destroy]
  resource :user, only: [:show]
end
