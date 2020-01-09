Rails.application.routes.draw do
  controller :sessions do
    get "login" => :new, as: "login"
    post "login" => :create
    get "logout" => :destroy, as: "logout"
  end
  resources :users do
    get :confirm_email, on: :member
  end
  resources :password_reset
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
