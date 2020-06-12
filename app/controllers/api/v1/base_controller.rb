require 'pagy/extras/headers'

class Api::V1::BaseController < ApplicationController
  include Banken
  include ErrorsHandler
  include Pagy::Backend
  after_action :set_pagy_header, if: -> { @pagy }

  # rescue_from Exception, with: :notify_500
  rescue_from Banken::NotAuthorizedError, with: :not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found
  rescue_from Twitter::Error::TooManyRequests, with: :rescue_limited_twitter_requests

  protected

  def set_pagy_header
    pagy_headers_merge(@pagy)
    response.headers.merge!({ 'Request-Url' => request.path_info })
  end
end
