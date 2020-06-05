require 'pagy/extras/headers'

class Api::V1::BaseController < ApplicationController
  include Banken
  include Pagy::Backend
  after_action :set_pagy_header, if: -> { @pagy }

  rescue_from Banken::NotAuthorizedError, with: :not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found
  rescue_from Twitter::Error::TooManyRequests, with: :rescue_limited_twitter_requests

  protected

  def set_pagy_header
    pagy_headers_merge(@pagy)
    response.headers.merge!({ 'Request-Url' => request.path_info })
  end

  def not_authenticated
    error_json = {
      'code' => '401',
      'title' => '認証されていません。',
      'message' => 'ログインしてください。'
    }
    render json: { 'error': error_json }, status: :unauthorized
  end

  def not_authorized
    error_json = {
      'code' => '403',
      'title' => '閲覧できません。',
      'message' => 'リソースへのアクセスが許可されていません。'
    }
    render json: { 'error': error_json }, status: :forbidden
  end

  def rescue_not_found
    error_json = {
      'code' => '404',
      'title' => 'リソースが見つかりませんでした。',
      'message' => 'データが見つかりませんでした。アドレスを確認してください。'
    }
    render json: { 'error': error_json }, status: :not_found
  end

  def rescue_limited_twitter_requests
    error_json = {
      'code' => '429',
      'title' => 'Twitter APIが制限されています。',
      'message' => '現在リクエストが集中しています。15分後に再度試してください。'
    }
    render json: { 'error': error_json }, status: :too_many_requests
  end
end
