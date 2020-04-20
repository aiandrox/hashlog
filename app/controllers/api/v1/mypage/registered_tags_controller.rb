class Api::V1::Mypage::RegisteredTagsController < Api::V1::Mypage::BaseController
  def show
    registered_tag = current_user.registered_tags.find(params[:id])
    tweets = registered_tag.tweets
    result_values = {
      user: current_user,
      registered_tags: registered_tag,
      tweets: tweets
    }
    render json: result_values
  end

  def create
    result_values = if current_user.register_tag(tag_params[:name])
                      {
                        flash: {
                          type: 'success',
                          message: 'ハッシュタグを登録しました'
                        }
                      }
                    else
                      {
                        flash: {
                          type: 'error',
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
