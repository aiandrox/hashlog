class Api::V1::BaseController < ApplicationController
  rescue_from Twitter::Error::TooManyRequests, with: :rescue_limited_twitter_requests

  def rescue_limited_twitter_requests
    render json: { flash: { type: 'error', message: 'リクエストが集中しています。15分後に再度試してください。' } }
  end

  protected

  def not_authenticated
    render status: 401, json: { flash: { type: 'error', message: 'ログインしてください' } }
  end
end
