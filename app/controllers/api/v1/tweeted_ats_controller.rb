class Api::V1::TweetedAtsController < Api::V1::BaseController
  def index
    registered_tag = RegisteredTag.find(params[:registered_tag_id])
    authorize!(registered_tag)
    tweeted_ats = registered_tag.tweets.tweeted_ats.map(&:tweeted_at).map(&:to_s)
    render json: { tweetedAts: tweeted_ats }
  end
end
