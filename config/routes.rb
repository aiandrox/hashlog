Rails.application.routes.draw do
  root 'static_pages#top'
  # ログイン、ログアウト
  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
  delete 'logout', to: 'user_sessions#destroy'
  # マイページ
  resource :mypage, only: %i[show edit update destroy] do
    resources :tags, only: %i[new create]
    resources :tag_logs, only: %i[show edit update destroy], shallow: true
  end

  resources :users, param: :uuid, only: :show do
    resources :tag_logs, only: :show
  end
end
