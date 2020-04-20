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
    user = User.find(user_params[:id]) # TODO: current_userがとってこれないので突貫
    result_values = if user.register_tag(tag_params[:name])
                      {
                        flash: {
                          type: 'notice',
                          message: 'ハッシュタグを登録しました'
                        }
                      }
                    else
                      {
                        flash: {
                          type: 'alert',
                          message: 'ハッシュタグを登録できませんでした'
                        }
                      }
                    end
    render json: result_values
  end

  private

  def user_params
    params.require(:user).permit(:id)
  end

  def tag_params
    params.require(:tag).permit(:privacy, :remind_day, :name)
  end
end
