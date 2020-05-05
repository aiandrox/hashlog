Rails.application.routes.draw do
  root 'static_pages#top'
  get 'mypage/dashboard', to: 'static_pages#mypage'
  get 'mypage/tags/:id', to: 'static_pages#top'

  namespace :api do
    namespace :v1 do
      resource :mypage, only: [:show]
      # namespace :mypage do
      #   resources :registered_tags, only: %i[show create], path: :tags
      # end
      resources :users, param: :uuid, only: %i[index show destroy] do
        get 'current', on: :collection
        resources :registered_tags, only: %i[index show create destroy]
      end
      resources :registered_tags, only: %i[index show]
      resources :tags, only: :index
      resources :tweets, only: :destroy
      # # ログイン、ログアウト
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
end
