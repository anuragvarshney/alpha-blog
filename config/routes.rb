Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  resources :articles, only: [ :show, :index, :create, :update, :destroy ]
  resources :users, only: [ :index, :show, :update, :destroy ]
  post "signup", to: "authentication#signup"
  post "login", to: "authentication#login"
  delete "logout", to: "authentication#logout"
end
