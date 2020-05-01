class Api::V1::TweetsController < Api::V1::BaseController
  before_action :require_login

  # 開発時 & 管理者用
  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy!
    result_values = {
      flash: {
        type: 'success',
        message: 'ツイートを削除しました'
      }
    }
    render json: result_values
  end
end
