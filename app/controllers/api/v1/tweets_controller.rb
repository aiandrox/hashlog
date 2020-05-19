require 'pagy/extras/headers'

class Api::V1::TweetsController < Api::V1::BaseController
  include Pagy::Backend

  def index
    registered_tag = RegisteredTag.find(params[:registered_tag_id])
    pagy, tweets = pagy(registered_tag.tweets.desc)
    pagy_headers_merge(pagy)
    render json: tweets
  end

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
