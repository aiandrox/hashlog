class Api::V1::BaseController < ApplicationController
  rescue_from Twitter::Error::TooManyRequests, with: :rescue_limited_twitter_requests
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found
  # rescue_from ActionController::RoutingError, with: :rescue_not_found

  # def routing_error
  #   raise ActionController::RoutingError, params[:path]
  # end

  protected

  def rescue_limited_twitter_requests
    head 429
  end

  def rescue_not_found
    head 404
  end

  def not_authenticated
    head 403
  end
end
