class Api::V1::Users::Current::TwitterDataController < Api::V1::BaseController
  before_action :require_login

  def update
    data = TwitterData::User.new(current_user).call
    current_user.update!(name: data[:name],
                         screen_name: data[:screen_name],
                         avatar_url: data[:avatar_url])
    render json: current_user, status: :ok
  rescue Twitter::Error::Forbidden, Twitter::Error::BadRequest
    error_json = {
      'code' => '403',
      'title' => 'アクセスが許可されていません',
      'detail' => 'ユーザー情報を確認してください',
      'messages' => ['再度ログインして試してください']
    }
    render json: { error: error_json }, status: :forbidden
  end
end
