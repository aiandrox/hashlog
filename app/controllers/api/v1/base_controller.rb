require 'pagy/extras/headers'

class Api::V1::BaseController < ApplicationController
  include Banken
  include ErrorsHandler
  include Pagy::Backend

  before_action :prepare_exception_notifier
  after_action :set_pagy_header, if: -> { @pagy }

  rescue_from Exception, with: :notify_500
  rescue_from Banken::NotAuthorizedError, with: :not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found
  rescue_from Twitter::Error::TooManyRequests, with: :rescue_limited_twitter_requests
  rescue_from TwitterAPIClient::NotFoundAuthenticationError, with: :rescue_not_found_authentication

  protected

  def set_pagy_header
    pagy_headers_merge(@pagy)
    response.headers.merge!({ 'Request-Url' => request.path_info })
  end

  private

  def prepare_exception_notifier
    return unless current_user

    request.env['exception_notifier.exception_data'] = {
      current_user: current_user.to_json
    }
  end
end
