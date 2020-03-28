Rails.application.routes.draw do
  root 'static_pages#index'
  resources :users, only: %i[create edit update show destroy]
end
