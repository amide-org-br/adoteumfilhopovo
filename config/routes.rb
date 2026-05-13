Rails.application.routes.draw do
  devise_for :users
  resources :adocaos
  resources :adotantes
  resources :website
  get 'website/adoption'

  # Health check endpoint used by Kamal's proxy.
  get "up" => "rails/health#show", as: :rails_health_check

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "website#index"
end
