class Api::V1::BaseController < ApplicationController
  rescue_from Twitter::Error::TooManyRequests, with: :rescue_limited_twitter_requests
  rescue_from ActiveRecord::RecordNotFound, with: :url_not_found

  def rescue_limited_twitter_requests
    render status: 429, json: { flash: { type: 'error', message: 'リクエストが集中しています。15分後に再度試してください' } }
  end

  def url_not_found
    head 404
  end

  protected

  def not_authenticated
    render status: 401, json: { flash: { type: 'error', message: 'ログインしてください' } }
  end
end
