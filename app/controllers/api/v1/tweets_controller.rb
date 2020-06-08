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
    render json: tweets
  end
end
