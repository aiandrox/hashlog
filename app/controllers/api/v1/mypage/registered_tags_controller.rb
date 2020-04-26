class Api::V1::Mypage::RegisteredTagsController < Api::V1::Mypage::BaseController
  def show
    registered_tag_params = 'registered_tags.id, name, tweeted_day_count,
                             privacy, remind_day, first_tweeted_at, last_tweeted_at'
    registered_tags = current_user.registered_tags
                                  .joins(:tag)
                                  .select(registered_tag_params)
    registered_tag = current_user.registered_tags.find(params[:id])
    tweets = registered_tag.tweets.desc
    result_values = {
      user: current_user,
      registered_tags: registered_tags,
      registered_tag: registered_tag,
      tweets: tweets
    }
    render json: result_values
  end
end
