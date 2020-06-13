require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :admin do
    root 'users#index'
    resources :users
    resources :registered_tags
    resources :tags
    resources :tweets
    resources :authentications
    # sidekiq
    mount Sidekiq::Web, at: '/sidekiq'
  end

  root 'static_pages#top'
  get 'mypage/dashboard', to: 'static_pages#top'
  get 'mypage/tags/:id', to: 'static_pages#top'
  get 'users/:uuid', to: 'static_pages#top'
  get 'users/:uuid/tags/:id', to: 'static_pages#top'
  get 'ranking/persistence', to: 'static_pages#top'

  namespace :api do
    namespace :v1 do
      resources :users, param: :uuid, only: %i[index show] do
        collection do
          resource :current, only: %i[show update destroy], module: :users do
            resources :registered_tags, only: %i[index], module: :current
          end
        end
        resources :registered_tags, only: %i[index], module: :users
      end
      # resources :registered_tagsより上に書く
      namespace :registered_tags do
        resources :persistences, only: %i[index]
      end
      resources :registered_tags, only: %i[index show create update destroy] do
        resources :tweets, only: %i[index]
      end
      resources :tags, only: %i[index]
      # ログイン、ログアウト
      post 'oauth/callback', to: 'oauths#callback'
      get 'oauth/callback', to: 'oauths#callback'
      get 'oauth/:provider', to: 'oauths#oauth'
      delete 'logout', to: 'user_sessions#destroy'
      # ゲストユーザーログイン
      post 'guest_login', to: 'user_sessions#guest_login'
    end
  end

  # 開発/テスト用ログイン
  get '/login_as/:user_id', to: 'development/sessions#login_as' unless Rails.env.production?

  # ルーティングエラーを拾う（getのみ）
  get '*path', to: 'static_pages#routing_error'
end
