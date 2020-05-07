class Api::V1::RegisteredTagsController < Api::V1::BaseController
  before_action :require_login, only: %i[create destroy]

  def index
    registered_tags = RegisteredTag.by_user(params[:user_uuid]).asc.includes(:tag)
    render json: registered_tags
  end

  def show
    registered_tag = RegisteredTag.includes(:tag).find(params[:id])
    render json: registered_tag
  end

  def create
    tag = Tag.find_or_initialize_by(name: tag_params[:name])
    if current_user.register_tag(tag)
      registered_tag = current_user.registered_tag(tag)
      render status: 201, json: { registeredTag: { id: registered_tag.id } }
    else
      error = {
        'status' => '422',
        'title' => '登録内容が適切ではありません。',
        'detail' => '登録内容を確認してください。'
      }
      render json: { 'errors': [error] }, status: 422
    end
  end

  def destroy
    registered_tag = current_user.registered_tags.find(params[:id])
    registered_tag.destroy!
  end

  private

  def tag_params
    params.require(:tag).permit(:privacy, :remind_day, :name)
  end
end
