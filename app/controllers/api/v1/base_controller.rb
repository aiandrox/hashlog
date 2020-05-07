class Api::V1::BaseController < ApplicationController
  rescue_from Twitter::Error::TooManyRequests, with: :rescue_limited_twitter_requests
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found
  # rescue_from ActionController::RoutingError, with: :rescue_not_found

  # def routing_error
  #   raise ActionController::RoutingError, params[:path]
  # end

  protected

  def rescue_limited_twitter_requests
    error = {
      'status' => '429',
      'title' => 'Twitter APIが制限されています。',
      'detail' => '15分後に再度試してください。'
    }
    render json: { 'errors': [error] }, status: 429 # TooManyRequests
  end

  def rescue_not_found
    error = {
      'status' => '404',
      'title' => 'リソースが見つかりませんでした。',
      'detail' => 'アドレスを確認してください。'
    }
    render json: { 'errors': [error] }, status: 404  # NotFound
  end

  def not_authenticated
    error = {
      'status' => '401',
      'title' => '認証されていません。',
      'detail' => 'ログインしてください。'
    }
    render json: { 'errors': [error] }, status: 401  # Unauthorized
  end
end
