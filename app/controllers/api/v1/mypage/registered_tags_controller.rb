class Api::V1::Mypage::RegisteredTagsController < Api::V1::Mypage::BaseController
  def show
    registered_tag_params = 'registered_tags.id, name, tweeted_day_count,
                             privacy, remind_day, first_tweeted_at, last_tweeted_at'
    registered_tags = current_user.registered_tags
                                  .joins(:tag)
                                  .select(registered_tag_params)
    registered_tag = current_user.registered_tags.find(params[:id])
    tweets = registered_tag.tweets
    result_values = {
      user: current_user,
      registered_tags: registered_tags,
      registered_tag: registered_tag,
      tweets: tweets
    }
    render json: result_values
  end

  def create
    tag = Tag.find_or_initialize_by(name: tag_params[:name])
    if current_user.register_tag(tag)
      registered_tag = current_user.registered_tag(tag: tag)
      result_values =  {
        flash: {
          type: 'success',
          message: 'ハッシュタグを登録しました'
        },
        tag_id: registered_tag.id
      }
    else
      result_values = {
        flash: {
          type: 'fail',
          message: 'ハッシュタグを登録できませんでした'
        }
      }
    end
    render json: result_values
  end

  private

  def tag_params
    params.require(:tag).permit(:privacy, :remind_day, :name)
  end
end
