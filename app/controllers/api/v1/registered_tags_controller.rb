class Api::V1::RegisteredTagsController < Api::V1::BaseController
  before_action :require_login, only: %i[create update destroy]

  def index
    registered_tags = RegisteredTag.opened.desc.includes(:user, :tag)
    if (count = params[:count])
      registered_tags.limit!(count)
    else
      @pagy, registered_tags = pagy(registered_tags)
    end
    render json: registered_tags
  end

  def show
    registered_tag = RegisteredTag.includes(:tag, :tweets).find(params[:id])
    authorize!(registered_tag)
    render json: registered_tag
  end

  def create
    tag = Tag.find_or_initialize_by(name: tag_params[:name])
    if current_user.register_tag(tag)
      registered_tag = current_user.registered_tag(tag)
      render status: :created, json: { registeredTag: { id: registered_tag.id } }
    else
      error_json = {
        'code' => 422,
        'title' => '登録内容が適切ではありません',
        'detail' => '登録内容を確認してください',
        'messages' => tag.errors.full_messages
      }
      render json: { error: error_json }, status: :unprocessable_entity
    end
  end

  def update
    registered_tag = current_user.registered_tags.find(params[:id])
    registered_tag.privacy = RegisteredTag.privacies_i18n.invert[tag_params[:privacy]]
    registered_tag.remind_day = tag_params[:remind_day]

    if registered_tag.save
      render json: registered_tag
    else
      error_json = {
        'code' => 422,
        'title' => '登録内容が適切ではありません',
        'detail' => '登録内容を確認してください',
        'messages' => registered_tag.errors.full_messages
      }
      render json: { error: error_json }, status: :unprocessable_entity
    end
  end

  def destroy
    registered_tag = current_user.registered_tags.find(params[:id])
    registered_tag.destroy!
  end

  private

  def tag_params
    permit_params = params.require(:tag).permit(:privacy, :remindDay, :name)
    permit_params.transform_keys(&:underscore)
  end
end
