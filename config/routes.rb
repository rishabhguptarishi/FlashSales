Rails.application.routes.draw do
  controller :sessions do
    get "login" => :new, as: "login"
    post "login" => :create
    get "logout" => :destroy, as: "logout"
  end
  get 'users/:token/confirm_email', to: 'users#confirm_email', as: 'confirm_email'
  resources :users
  resources :password_reset, param: :token

  namespace :admin do
    resources :deals
    resources :users
  end

  resources :deals, only: [:show, :index]

  root 'users#show', via: :all
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
