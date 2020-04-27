Rails.application.routes.draw do
  root 'static_pages#top'
  get 'vue', to: 'static_pages#vue'
  get 'mypage', to: 'static_pages#vue'
  get 'mypage/tags/:id', to: 'static_pages#vue'
  namespace :api do
    namespace :v1 do
      resource :mypage, only: [:show]
      namespace :mypage do
        resources :registered_tags, only: %i[show create], path: :tags
      end
      resources :registered_tags, only: %i[create destroy]
      resources :tweets, only: :destroy
      # ログイン、ログアウト
      post 'oauth/callback', to: 'oauths#callback'
      get 'oauth/callback', to: 'oauths#callback'
      get 'oauth/:provider', to: 'oauths#oauth'
      delete 'logout', to: 'user_sessions#destroy'
    end
  end

  # ログイン、ログアウト
  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
  delete 'logout', to: 'user_sessions#destroy'
  # ゲストユーザーログイン
  get 'guest_login', to: 'user_sessions#guest_login'

  # マイページ
  resource :mypage, only: %i[show edit update destroy]
  namespace :mypage do
    resources :tags, only: %i[new create]
    resources :registered_tags, only: %i[show edit update destroy]
  end

  resources :users, param: :uuid, only: :show do
    resources :registered_tags, only: :show
  end

  # 開発/テスト用ログイン
  unless Rails.env.production?
    get '/login_as/:user_id', to: 'development/sessions#login_as', as: :login_as
  end
end
