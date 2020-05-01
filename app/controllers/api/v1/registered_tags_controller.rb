class Api::V1::RegisteredTagsController < Api::V1::BaseController
  before_action :require_login

  def create
    tag = Tag.find_or_initialize_by(name: tag_params[:name])
    if current_user.register_tag(tag)
      registered_tag = current_user.registered_tag(tag: tag)
      result_values = {
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

  def destroy
    registered_tag = current_user.registered_tags.find(params[:id])
    registered_tag.destroy!
    result_values = {
      flash: {
        type: 'success',
        message: 'ハッシュタグを削除しました'
      }
    }
    render json: result_values
  end

  private

  def tag_params
    params.require(:tag).permit(:privacy, :remind_day, :name)
  end
end
