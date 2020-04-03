Rails.application.routes.draw do
  root 'static_pages#top'
  # ログイン、ログアウト
  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
  delete 'logout', to: 'user_sessions#destroy'
  # マイページ
  resource :mypage, only: %i[show edit update destroy]
  namespace :mypage do
    resources :tags, only: %i[new create]
    resources :registered_tags, only: %i[show edit update destroy]
  end

  resources :users, param: :uuid, only: :show do
    resources :registered_tags, only: :show
  end
end
