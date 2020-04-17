class Api::V1::Mypage::RegisteredTagsController < Api::V1::Mypage::BaseController
  def show
    user = current_user
    registered_tag = user.registered_tags.find(params[:id])
    tweets = registered_tag.tweets
    result_values = {
      user: user,
      registered_tags: registered_tag,
      tweets: tweets
    }
    render json: result_values
  end

  def create
    binding.pry
    result_values = if current_user.register_tag(tag_params[:name])
                      {
                        flash: {
                          type: 'notice',
                          message: t('messages.created', item: Tag.model_name.human)
                        }
                      }
                    else
                      {
                        flash: {
                          type: 'alert',
                          message: t('messages.not_created', item: Tag.model_name.human)
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
