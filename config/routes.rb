Rails.application.routes.draw do
  root 'static_pages#top'
  get 'mypage/dashboard', to: 'static_pages#top'
  get 'mypage/tags/:id', to: 'static_pages#top'
  get 'users/:uuid', to: 'static_pages#top'
  get 'users/:uuid/tags/:id', to: 'static_pages#top'

  namespace :api do
    namespace :v1 do
      resources :users, param: :uuid, only: %i[index show update destroy] do
        collection do
          get 'current'
          get 'current/registered_tags', to: 'current_registered_tags#index'
        end
        member do
          get 'registered_tags', to: 'user_registered_tags#index'
        end
      end
      resources :registered_tags, only: %i[index show create update destroy] do
        resources :tweets, only: %i[index]
      end
      resources :tags, only: %i[index]
      resources :tweets, only: %i[destroy] # そのうち消す
      # ログイン、ログアウト
      post 'oauth/callback', to: 'oauths#callback'
      get 'oauth/callback', to: 'oauths#callback'
      get 'oauth/:provider', to: 'oauths#oauth'
      delete 'logout', to: 'user_sessions#destroy'
      # ゲストユーザーログイン
      get 'guest_login', to: 'user_sessions#guest_login'
    end
  end

  # 開発/テスト用ログイン
  get '/login_as/:user_id', to: 'development/sessions#login_as' unless Rails.env.production?

  # sidekiq
  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'

  # ルーティングエラーを拾う（getのみ）
  get '*path', to: 'static_pages#routing_error'
end
