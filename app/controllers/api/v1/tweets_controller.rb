class Api::V1::TweetsController < Api::V1::BaseController
  def index
    registered_tag = RegisteredTag.find(params[:registered_tag_id])
    authorize!(registered_tag)
    tweets = registered_tag.tweets.desc
    if params[:date]
      date = Date.parse(params[:date])
      tweets = tweets.tweeted_at_date(date)
    end
    @pagy, tweets = pagy(tweets, items: 10) if params[:page]
    render json: tweets.includes([:images])
  end

  def create
    authorize!
    registered_tag = current_user.registered_tags.find(params[:registered_tag_id])
    update_client = TwitterAPI::Update.new(
      user: current_user,
      tag: registered_tag.tag,
      body: tweet_params[:body]
    )
    if (tweet_data = update_client.call)
      registered_tag.add_tweets([tweet_data])
      tweet = registered_tag.tweets.desc.first
      render json: tweet, status: :created
    else
      error_json = {
        'code' => 422,
        'title' => '登録内容が適切ではありません',
        'detail' => '登録内容を確認してください',
        'messages' => update_client.errors.full_messages
      }
      render json: { 'error': error_json }, status: :unprocessable_entity
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:body)
  end
end
