class Api::V1::RegisteredTagsController < Api::V1::BaseController

  def index
    registered_tags = RegisteredTag.asc
    render json: registered_tags
  end

  def show
    registered_tag = RegisteredTag.find(params[:id])
    render json: registered_tag
  end

  def create
    tag = Tag.find_or_initialize_by(name: tag_params[:name])
    if current_user.register_tag(tag)
      registered_tag = current_user.registered_tag(tag)
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
