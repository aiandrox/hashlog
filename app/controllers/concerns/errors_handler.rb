module ErrorsHandler
  extend ActiveSupport::Concern

  protected

  def notify500(exception)
    logger.error "500 error: #{exception.message}\n#{exception.backtrace}" if Rails.env.production?
    raise exception
  end

  def not_authenticated
    error_json = {
      'code' => 401,
      'title' => '認証されていません',
      'messages' => ['ログインしてください']
    }
    render json: { error: error_json }, status: :unauthorized
  end

  def not_authorized
    error_json = {
      'code' => 403,
      'title' => '閲覧できません',
      'messages' => ['アクセスが許可されていません']
    }
    render json: { error: error_json }, status: :forbidden
  end

  def rescue_not_found
    error_json = {
      'code' => 404,
      'title' => 'リソースが見つかりませんでした',
      'messages' => ['データが見つかりませんでした。アドレスを確認してください']
    }
    render json: { error: error_json }, status: :not_found
  end

  def rescue_limited_twitter_requests
    error_json = {
      'code' => 429,
      'title' => 'Twitter APIが制限されています',
      'messages' => ['現在リクエストが集中しています。15分後に再度試してください']
    }
    render json: { error: error_json }, status: :too_many_requests
  end

  def rescue_not_found_authentication
    error_json = {
      'code' => 400,
      'title' => 'Twitter認証情報が無効です',
      'messages' => ['再度ログインして試してください']
    }
    render json: { error: error_json }, status: :bad_request
  end
end
